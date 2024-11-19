import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitory_project/Item/view/item_rent_screen.dart';
import 'package:unitory_project/providers/login_provider.dart';
import 'package:unitory_project/user/view/login_screen.dart';
import 'package:unitory_project/user/view/my_page_screen.dart';

import '../../Item/view/item_screen.dart';
import '../const/colors.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with TickerProviderStateMixin {
  int index = 0;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: Duration.zero,
    );
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
            onPressed: () {},
            icon: Icon(
              Icons.search_outlined,
              size: 32.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
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
              Icons.notifications,
              size: 32.0,
              color: BODY_TEXT_COLOR,
            ),
          )
        ],
      ),
      floatingActionButton: tabController.index == 0
          ? Container(
              width: 84.0,
              height: 44.0,
              child: FloatingActionButton(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
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
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                ),
                backgroundColor: PRIMARY_COLOR,
                foregroundColor: Colors.white,
              ),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: TabBarView(
        children: [
          ItemScreen(),
          Container(
            color: Colors.redAccent,
            child: Center(
              child: Text('page1'),
            ),
          ),
          MyPageScreen(),
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
}
