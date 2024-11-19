import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitory_project/common/const/colors.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        12.0,
      ),
      child: Column(
        children: [
          userCard(),
          SizedBox(
            height: 20.0,
          ),
          favAndBorrowedList(),
        ],
      ),
    );
  }

  Widget userCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 20.0,
        ),
        child: Row(
          children: [
            edit
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.person_alt_circle_fill,
                        size: 80.0,
                        color: BODY_TEXT_COLOR,
                      ),
                      Icon(
                        Icons.circle,
                        size: 80.0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 32.0,
                        color: Colors.white,
                      ),
                    ],
                  )
                : Icon(
                    CupertinoIcons.person_alt_circle_fill,
                    size: 80.0,
                    color: BODY_TEXT_COLOR,
                  ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userName(),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "김서윤",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: BODY_TEXT_COLOR,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "20050905",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: BODY_TEXT_COLOR,
                    ),
                  ),
                ],
              ),
            ),
            editButton(),
          ],
        ),
      ),
    );
  }

  Widget userIcon() {
    return Icon(
      CupertinoIcons.person_alt_circle_fill,
      size: 80.0,
      color: BODY_TEXT_COLOR,
    );
  }

  Widget userName() {
    return edit
        ? Row(
            children: [
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
              Icon(
                Icons.edit_square,
                size: 18.0,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          )
        : Text(
            "유니토리사용자",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: Colors.black.withOpacity(0.7),
            ),
          );
  }

  Widget editButton() {
    return Column(
      children: [
        SizedBox(
          height: 44.0,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              edit = !edit;
            });
          },
          child: Container(
            width: 60.0,
            decoration: BoxDecoration(
              color: edit ? PRIMARY_COLOR : INPUT_BD_COLOR,
              borderRadius: BorderRadius.circular(
                4.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                8.0,
              ),
              child: edit
                  ? Center(
                    child: Text(
                        "완료",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                  )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_square,
                          size: 12.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          "편집",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget favAndBorrowedList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 28.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 28.0,
                  color: BODY_TEXT_COLOR,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  "관심 목록",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: BODY_TEXT_COLOR,
                  ),
                ),
              ],
            ),
            Container(
              width: 1.0,
              height: 60.0,
              color: BODY_TEXT_COLOR.withOpacity(0.4),
            ),
            Column(
              children: [
                Icon(
                  Icons.library_books,
                  size: 28.0,
                  color: BODY_TEXT_COLOR,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  "대여 내역",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: BODY_TEXT_COLOR,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
