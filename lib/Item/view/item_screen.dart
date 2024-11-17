import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../component/item_card.dart';
import '../model/item_model.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  // 페이지네이션 구현
  final List<ItemCard> itemCards = []; // 아이템 리스트
  DocumentSnapshot? lastDocument; // DB에서 불러온 마지막 문서
  final int limit = 2; // 한 번에 가져올 문서 개수
  bool hasMoreData = true; // 추가 데이터가 있는지 여부
  bool isLoading = true; // 사용자가 스크롤 할 때만 추가적인 데이터 로드

  late final RefreshController refreshController;

  @override
  void initState() {
    refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemCard>>(
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
                if (i < itemCards.length) {
                  return itemCards[i];
                } else {
                  // 잘못된 인덱스로 접근하지 않도록 기본값 반환
                  return SizedBox.shrink();
                }
              },
              separatorBuilder: (context, i) => SizedBox(height: 16.0),
            ),
          );
        }
      },
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

                // 디테일 화면 구현을 위한 필드들
                String description = data['description'];
                String userID = data['userID'];
                String fileRef = data['fileRef'];

                itemCards.add(ItemCard(
                  thumbUrl: thumbUrl,
                  title: title,
                  price: price,
                  itemRentalPeriodType: itemRentalPeriodType,
                  uploadTime: uploadTime,

                  // 디테일 화면 구현을 위한 필드들
                  description: description,
                  userID: userID,
                  fileRef: fileRef,
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

                // 디테일 화면 구현을 위한 필드들
                String description = data['description'];
                String userID = data['userID'];
                String fileRef = data['fileRef'];

                itemCards.add(ItemCard(
                  thumbUrl: thumbUrl,
                  title: title,
                  price: price,
                  itemRentalPeriodType: itemRentalPeriodType,
                  uploadTime: uploadTime,

                  // 디테일 화면 구현을 위한 필드들
                  description: description,
                  userID: userID,
                  fileRef: fileRef,
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