import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unitory_project/common/const/colors.dart';

import '../../providers/login_provider.dart';

class MyPageScreen extends StatefulWidget {
  String userName = "유니토리사용자";
  final String userID;

  MyPageScreen({
    super.key,
    required this.userID,
  });

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  bool edit = false;

  // 프로필 편집
  String? profilePicUrl;

  XFile? profilePic;
  final imagePicker = ImagePicker();

  @override
  void initState() {
    // '미리' 프로필 사진 url 불러오기
    fetchProfilePicUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<LoginProvider>(context, listen: false).user!.uid;

    return Padding(
      padding: EdgeInsets.all(
        12.0,
      ),
      child: Column(
        children: [
          userCard(userID),
          SizedBox(
            height: 20.0,
          ),
          favAndBorrowedList(),
        ],
      ),
    );
  }

  Widget userCard(String userID) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userIconBuilder(),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userNameBuilder(userID),
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

  Future<String> fetchProfilePicUrl() async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userID)
        .get();
    final userData = userDoc.data();
    if (userData != null && userData["profilePic"] != "") {
      profilePicUrl = userData["profilePic"];
      return profilePicUrl!;
    } else {
      return "";
    }
  }

  Future<void> getImage() async {
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profilePic = pickedFile;
      });
    }
  }

  void removeImage() {
    setState(() {
      profilePic = null;
    });
  }

  Future<void> uploadProfilePic() async {
    if (profilePic == null) {
      print("선택된 프로필 사진이 없습니다.");
      return;
    }

    // XFile 객체를 File 객체로 변환
    File file = File(profilePic!.path);

    // 파일 경로 설정
    String fileRef =
        "${widget.userID}/${DateTime.now().millisecondsSinceEpoch}";

    // 파일 업로드
    final storageRef = FirebaseStorage.instance.ref();
    try {
      await storageRef.child(fileRef).putFile(file);
    } on FirebaseException catch (e) {
      print(e.message);

      // Transaction
      // Storage에서 업로드된 데이터 삭제
      try {
        await storageRef.child(fileRef).delete();
      } catch (deleteError) {
        print("Failed to delete data from storage");
      }
    }

    String profilePicUrl = await storageRef.child(fileRef).getDownloadURL();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .update({"profilePic": profilePicUrl});

      print("Field 'profilePic' updated successfully.");
    } catch (e) {
      print("Error updating field: $e");
    }
  }

  Widget userIconBuilder() {
    if (edit) {
      if (profilePic != null) {
        return GestureDetector(
          onTap: () {
            getImage();
          },
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: profilePic == null ? 80.0 : 60,
                    height: profilePic == null ? 80.0 : 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: FileImage(File(profilePic!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.circle,
                    size: profilePic == null ? 80.0 : 70,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 32.0,
                    color: Colors.white,
                  ),
                ],
              ),
              if (profilePic != null)
                GestureDetector(
                  onTap: () {
                    removeImage();
                  },
                  child: Container(
                    width: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: BODY_TEXT_COLOR.withOpacity(0.5),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        "기본이미지",
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {
            getImage();
          },
          child: Stack(
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
          ),
        );
      }
    } else { // 편집 환경이 아니라면
      // DB에 저장된 프로필 사진이 있다면
      return FutureBuilder(
        future: fetchProfilePicUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 80.0,
              width: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: INPUT_BD_COLOR,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // 에러 처리
            return Center(
              child: Text("Failed to load profile picture"),
            );
          } else if (snapshot.data == "") {
            // 데이터가 없는 경우
            if (profilePic != null) {
              return Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(File(profilePic!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return Icon(
                CupertinoIcons.person_alt_circle_fill,
                size: 80.0,
                color: BODY_TEXT_COLOR,
              );
            }
          } else {
            // 데이터가 성공적으로 로드된 경우
            return ClipOval(
              child: Image.network(
                snapshot.data!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            );
          }
        },
      );
    }
  }

  Widget userNameBuilder(String userID) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(userID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 25.0,
            child: Center(
              child: CircularProgressIndicator(),
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
          if (widget.userName == "유니토리사용자") {
            widget.userName = userInfo["name"];
          }

          return userName();
        }
      },
    );
  }

  Widget userName() {
    if (edit) {
      return Row(
        children: [
          Text(
            widget.userName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          SizedBox(
            width: 4.0,
          ),
          GestureDetector(
            onTap: () {
              print("edit name button pressed");
            },
            child: Icon(
              Icons.edit_square,
              size: 18.0,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      );
    } else {
      return Text(
        widget.userName,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: Colors.black.withOpacity(0.7),
        ),
      );
    }
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
              if (edit == false) {
                uploadProfilePic();
              }
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