import 'package:flutter/material.dart';

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
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UNITORY',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
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
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              size: 32.0,
              color: BODY_TEXT_COLOR,
            ),
          )
        ],
      ),
      body: TabBarView(
        children: [
          Center(
            child: Text('page0'),
          ),
          Center(
            child: Text('page1'),
          ),
          Center(
            child: Text('page2'),
          ),
        ],
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 30.0,),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_rounded, size: 30.0,),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30.0,),
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

