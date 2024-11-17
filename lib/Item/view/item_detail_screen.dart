import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitory_project/common/component/custom_button.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';

import '../model/item_model.dart';

class ItemDetailScreen extends StatefulWidget {
  final String thumbUrl;
  final String title;
  final int price;
  final ItemRentalPeriodType itemRentalPeriodType;
  final DateTime uploadTime;

  // 디테일 화면 구현을 위한 필드들
  final String userID;
  final String description;
  final String fileRef;

  // Carousel을 위한 변수
  int current = 0;

  ItemDetailScreen({
    super.key,
    required this.thumbUrl,
    required this.title,
    required this.price,
    required this.itemRentalPeriodType,
    required this.uploadTime,
    required this.userID,
    required this.description,
    required this.fileRef,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool addToFav = false;

  late final CarouselController carouselController;

  @override
  void initState() {
    carouselController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "",
      bottomNavigationBar: bottomAppbar(),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            itemImg(),
            userDesc(),
            itemMainDesc(),
            itemDetailDesc(),
          ],
        ),
      ),
    );
  }

  Widget bottomAppbar() {
    return BottomAppBar(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: [
            addToFavButton(),
            SizedBox(
              width: 16.0,
            ),
            chatButton(),
          ],
        ),
      ),
    );
  }

  Widget itemImg() {
    return FutureBuilder(
      future: getAllImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // 에러 처리
          return Center(
            child: Text("Failed to load images"),
          );
        } else if (!snapshot.hasData) {
          // 데이터가 없는 경우
          return Image.asset(
            "asset/img/no_img.jpg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          );
        } else {
          // 데이터가 성공적으로 로드된 경우
          List<String> images = snapshot.data!;
          return carousel(images);
        }
      },
    );
  }

  Widget userDesc() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userID)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 68.0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.black.withOpacity(0.2), width: 0.5),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                12.0,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // 에러 처리
          return Center(
            child: Text("Failed to load user info"),
          );
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          // 데이터가 없는 경우
          return Center(
            child: Text("User not found"),
          );
        } else {
          // 데이터가 성공적으로 로드된 경우
          final userInfo = snapshot.data!.data()!;
          final userName = userInfo["name"];
          final userLikes = userInfo['likes'];

          return userCard(userName, userLikes);
        }
      },
    );
  }

  Widget itemMainDesc() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.05),
            width: 8.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              children: [
                Text(
                  "${widget.price.toString()}원",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      color: PRIMARY_COLOR),
                ),
                Text(
                  whichType(widget.itemRentalPeriodType),
                  style: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  uploadTimeDiff(widget.uploadTime),
                  style: TextStyle(
                    color: BODY_TEXT_COLOR,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget itemDetailDesc() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "상세설명",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: BODY_TEXT_COLOR),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 16.0,
              color: BODY_TEXT_COLOR,
            ),
          )
        ],
      ),
    );
  }

  String uploadTimeDiff(DateTime uploadTime) {
    Duration diff = DateTime.now().difference(uploadTime);

    if (diff.inDays >= 1) {
      return "${diff.inDays}일 전";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours}시간 전";
    } else {
      return "${diff.inMinutes}분 전";
    }
  }

  String whichType(ItemRentalPeriodType type) {
    if (type == ItemRentalPeriodType.month) {
      return " /월";
    } else if (type == ItemRentalPeriodType.week) {
      return " /주";
    } else {
      return " /일";
    }
  }

  Future<List<String>> getAllImages() async {
    List<String> downloadUrls = [];

    try {
      // Storage 참조 접근
      final storageRef = FirebaseStorage.instance.ref().child(widget.fileRef);

      // 해당 디렉토리의 모든 파일 나열
      final imgList = await storageRef.listAll();

      // 각 파일의 다운로드 URL 가져오기
      for (var item in imgList.items) {
        String downloadUrl = await item.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      print("Failed to fetch images from storage");
      return [];
    }
  }

  Widget addToFavButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          addToFav = !addToFav;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: BODY_TEXT_COLOR,
            ),
            borderRadius: BorderRadius.circular(
              8.0,
            )),
        child: Padding(
          padding: EdgeInsets.all(
            12.0,
          ),
          child: addToFav
              ? Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 28.0,
                )
              : Icon(
                  Icons.favorite_border,
                  color: BODY_TEXT_COLOR,
                  size: 28.0,
                ),
        ),
      ),
    );
  }

  Widget chatButton() {
    return Expanded(
      child: CustomButton(
        text: "채팅하기",
        textColor: Colors.white,
        bgColor: PRIMARY_COLOR,
        textSize: 18.0,
      ),
    );
  }

  Widget carousel(List<String> images) {
    return Stack(
      children: [
        CarouselSlider(
          items: images.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Image.network(
                  url,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            initialPage: widget.current,
            viewportFraction: 1,
            height: MediaQuery.of(context).size.width,
            onPageChanged: (index, reason) {
              setState(() {
                widget.current = index;
              });
            },
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.map((e) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (images[widget.current] == e)
                          ? Colors.white // 현재 페이지는 흰색
                          : Colors.grey, // 다른 페이지는 회색
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget userCard(String userName, String userLikes) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.black.withOpacity(0.2), width: 0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          12.0,
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.person_alt_circle_fill,
              size: 44.0,
            ),
            SizedBox(
              width: 6.0,
            ),
            Text(
              userName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Row(
              children: [
                Text(
                  "[",
                  style: TextStyle(color: BODY_TEXT_COLOR),
                ),
                Text(
                  "친절도",
                  style: TextStyle(
                    color: BODY_TEXT_COLOR,
                    decoration: TextDecoration.underline,
                    decorationColor: BODY_TEXT_COLOR,
                  ),
                ),
                Text(
                  ": ",
                  style: TextStyle(color: BODY_TEXT_COLOR),
                ),
                Text(
                  "+${userLikes}",
                  style: TextStyle(
                      color: Colors.teal.withOpacity(0.5),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "]",
                  style: TextStyle(color: BODY_TEXT_COLOR),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
