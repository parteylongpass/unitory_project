import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitory_project/common/component/custom_button.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool addToFav = false;

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
            GestureDetector(
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
                  child: addToFav? Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 28.0,
                  ) : Icon(
                    Icons.favorite_border,
                    color: BODY_TEXT_COLOR,
                    size: 28.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: CustomButton(
                text: "채팅하기",
                textColor: Colors.white,
                bgColor: PRIMARY_COLOR,
                textSize: 18.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemImg() {
    return Image.asset(
      "asset/img/kenzo.jpg",
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }

  Widget userDesc() {
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
              "유니토리사용자",
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
                  "+3",
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
              "겐조 맨투맨",
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Text(
                  "10000원",
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                      color: PRIMARY_COLOR),
                ),
                Text(
                  " /주",
                  style: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "19분 전",
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
            "겐조 맨투맨 M사이즈고요 상태 깨끗하고 멀쩡합니다 대여는 3일이하만 가능하고요 더 궁금하신 거 있음 챗 주세요",
            style: TextStyle(
              fontSize: 16.0,
              color: BODY_TEXT_COLOR,
            ),
          )
        ],
      ),
    );
  }
}
