import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitory_project/common/component/custom_button.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';
import 'package:unitory_project/providers/add_to_favorite_provider.dart';
import 'package:unitory_project/providers/indicator_provider.dart';

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

  // 캐싱을 위한 변수들
  String userName = "유니토리사용자";
  String userLikes = "0";

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
  late final CarouselController carouselController;

  @override
  void initState() {
    carouselController = CarouselController();

    // current를 0으로 초기화
    // addToFav를 false로 초기화
    Future.microtask(() {
      context.read<IndicatorProvider>().initializeIndicator();
      context.read<AddToFavoriteProvider>().initializeAddToFav();
    });
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
          final images = snapshot.data!;
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

          // 불러온 값들을 로컬 변수에 저장(캐싱 흉내)
          if (widget.userName == "유니토리사용자" && widget.userLikes == "0") {
            widget.userName = userInfo["name"];
            widget.userLikes = userInfo['likes'];
          }

          return userCard(widget.userName, widget.userLikes);
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

  Future<List<Image>> getAllImages() async {
    List<String> downloadUrls = [];

    List<Image> imageList = [];
    try {
      // Storage 참조 접근
      final storageRef = FirebaseStorage.instance.ref().child(widget.fileRef);

      // 해당 디렉토리의 모든 파일 나열
      final imgList = await storageRef.listAll();

      // 각 파일의 다운로드 URL 가져오기
      for (var item in imgList.items) {
        String downloadUrl = await item.getDownloadURL();
        downloadUrls.add(downloadUrl);

        // 미리 이미지들을 다운로드(캐싱 흉내)
        imageList.add(
          Image.network(
            downloadUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        );
      }

      return imageList;
    } catch (e) {
      print("Failed to fetch images from storage");
      return [];
    }
  }

  Widget addToFavButton() {
    return Consumer<AddToFavoriteProvider>(
      builder: (context, addToFavProvider, child) {
        return GestureDetector(
          onTap: () {
            addToFavProvider.changeAddToFav();
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
              child: addToFavProvider.addToFav
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
      },
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

  Widget carousel(List<Image> images) {
    return Consumer<IndicatorProvider>(
        builder: (context, indicatorProvider, child) {
      return Stack(
        children: [
          CarouselSlider(
            items: images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return image;
                },
              );
            }).toList(),
            options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 1,
              height: MediaQuery.of(context).size.width,
              onPageChanged: (index, reason) {
                indicatorProvider.updateIndicator(index);
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
                        color: (images[indicatorProvider.current] == e)
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
    });
  }

  Widget userCard(String userName, String userLikes) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 0.5),
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
              color: BODY_TEXT_COLOR,
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
