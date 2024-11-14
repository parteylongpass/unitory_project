import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unitory_project/Item/view/item_rent_screen.dart';
import 'package:unitory_project/providers/login_provider.dart';
import 'package:unitory_project/user/view/login_screen.dart';

import '../../Item/component/item_card.dart';
import '../../Item/model/item_model.dart';
import '../const/colors.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with TickerProviderStateMixin {
  int index = 0;
  late final TabController tabController;
  late final RefreshController refreshController;

  // 페이지네이션 구현
  final List<ItemCard> itemCards = []; // 아이템 리스트
  DocumentSnapshot? lastDocument; // DB에서 불러온 마지막 문서
  final int limit = 2; // 한 번에 가져올 문서 개수
  bool hasMoreData = true; // 추가 데이터가 있는지 여부
  bool isLoading = true; // 사용자가 스크롤 할 때만 추가적인 데이터 로드

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: Duration.zero,
    );

    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    // Provider가 잘 동작하는지 테스트 -> user.~로 확인 가능
    final user = Provider.of<LoginProvider>(context, listen: false).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'UNITORY',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: BODY_TEXT_COLOR,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              // 임시로 로그아웃 버튼으로 사용
              Provider.of<LoginProvider>(context, listen: false).signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.search_outlined,
              size: 32.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              size: 32.0,
              color: BODY_TEXT_COLOR,
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        width: 84.0,
        height: 44.0,
        child: FloatingActionButton(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ItemRentScreen(),
              ),
            );
          },
          child: FittedBox(
            child: Row(
              children: [
                Icon(Icons.add),
                Text(
                  '글쓰기',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
                )
              ],
            ),
          ),
          backgroundColor: PRIMARY_COLOR,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: TabBarView(
        children: [
          FutureBuilder<List<ItemCard>>(
            future: fetchAllItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No items available.'));
              } else {
                return SmartRefresher(
                  controller: refreshController,
                  enablePullUp: true,
                  onRefresh: () async {
                    // 초기화 작업
                    lastDocument = null;
                    itemCards.clear();
                    hasMoreData = true;
                    isLoading = true;
                    await fetchAllItems(); // 새로고침 시 fetchAllItems 호출
                    isLoading = false;
                    setState(() {}); // 상태를 갱신하여 UI 업데이트

                    refreshController.refreshCompleted();
                  },
                  onLoading: () async {
                    isLoading = true;
                    await fetchAllItems(); // 새로고침 시 fetchAllItems 호출
                    isLoading = false;
                    setState(() {}); // 상태를 갱신하여 UI 업데이트

                    refreshController.loadComplete();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(12.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return snapshot.data![i];
                    },
                    separatorBuilder: (context, i) => SizedBox(height: 16.0),
                  ),
                );
              }
            },
          ),
          Container(
            color: Colors.redAccent,
            child: Center(
              child: Text('page1'),
            ),
          ),
          Center(
            child: Text('page2'),
          ),
        ],
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              size: 30.0,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.question_answer_rounded,
              size: 30.0,
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30.0,
            ),
            label: '마이페이지',
          ),
        ],
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            tabController.animateTo(index);
          });
        },
        currentIndex: tabController.index,
      ),
    );
  }

  Future<List<ItemCard>> fetchAllItems() async {
    if (!hasMoreData) { // 더 불러올 데이터가 없는 경우 기존의 리스트 반환
      return itemCards;
    }

    if(isLoading) { // 사용자가 스크롤 할 때만 추가적인 데이터 로드
      final db = FirebaseFirestore.instance;

      if (lastDocument == null) { // 맨 처음 DB에서 데이터를 불러올 때
        // 맨 처음 DB에서 데이터를 불러올 때
        final first = db
            .collection("items")
            .orderBy(
          "uploadTime",
          descending: true,
        )
            .limit(limit);

        await first.get().then(
              (documentSnapshots) {
            if (documentSnapshots.docs.isNotEmpty) {
              lastDocument = documentSnapshots.docs[documentSnapshots.size - 1];

              for (var itemDoc in documentSnapshots.docs) {
                final data = itemDoc.data();

                String thumbUrl = data['thumbUrl'];
                String title = data['title'];
                int price = int.parse(data['price']);
                ItemRentalPeriodType itemRentalPeriodType =
                parseType(data['itemRentalPeriodType']);
                DateTime uploadTime = DateTime.parse(data['uploadTime']);

                itemCards.add(ItemCard(
                  thumbUrl: thumbUrl,
                  title: title,
                  price: price,
                  itemRentalPeriodType: itemRentalPeriodType,
                  uploadTime: uploadTime,
                ));
              }
            } else {
              hasMoreData = false;
            }
          },
          onError: (e) => print("Error completing: $e"),
        );
        isLoading = false; // 맨 처음 데이터 불러온 후에는 사용자가 스크롤 할 때만 추가적 데이터 로드
      } else {
        final next = db
            .collection("items")
            .orderBy(
          "uploadTime",
          descending: true,
        )
            .startAfterDocument(lastDocument!)
            .limit(limit);

        await next.get().then(
              (documentSnapshots) {
            if (documentSnapshots.docs.isNotEmpty) {
              lastDocument = documentSnapshots.docs[documentSnapshots.size - 1];

              for (var itemDoc in documentSnapshots.docs) {
                final data = itemDoc.data();

                String thumbUrl = data['thumbUrl'];
                String title = data['title'];
                int price = int.parse(data['price']);
                ItemRentalPeriodType itemRentalPeriodType =
                parseType(data['itemRentalPeriodType']);
                DateTime uploadTime = DateTime.parse(data['uploadTime']);

                itemCards.add(ItemCard(
                  thumbUrl: thumbUrl,
                  title: title,
                  price: price,
                  itemRentalPeriodType: itemRentalPeriodType,
                  uploadTime: uploadTime,
                ));
              }
            } else {
              hasMoreData = false;
            }
          },
          onError: (e) => print("Error completing: $e"),
        );
      }

      return itemCards;
    } else {
      return itemCards;
    }
  }

  ItemRentalPeriodType parseType(String type) {
    if (type == "ItemRentalPeriodType.month") {
      return ItemRentalPeriodType.month;
    } else if (type == "ItemRentalPeriodType.week") {
      return ItemRentalPeriodType.week;
    } else {
      return ItemRentalPeriodType.day;
    }
  }
}
