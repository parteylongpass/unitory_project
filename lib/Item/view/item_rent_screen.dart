import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unitory_project/Item/model/item_model.dart';
import 'package:unitory_project/common/component/custom_button.dart';
import 'package:unitory_project/common/component/custom_text_form_field.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';

import '../../providers/login_provider.dart';

class ItemRentScreen extends StatefulWidget {
  ItemRentScreen({super.key});

  @override
  State<ItemRentScreen> createState() => _ItemRentScreenState();
}

class _ItemRentScreenState extends State<ItemRentScreen> {
  ItemRentalPeriodType itemRentalPeriodType = ItemRentalPeriodType.month;
  bool isMonthSelected = true;
  bool isWeekSelected = false;
  bool isDaySelected = false;
  late List<bool> isSelected;
  int count = 0;

  List<XFile> images = [];
  final ImagePicker imagePicker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool isUploading = false;

  @override
  void initState() {
    isSelected = [isMonthSelected, isWeekSelected, isDaySelected];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "",
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            '상품 정보',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (count != 3) {
                                count == 2 ? getImage() : getImages();
                              } else {
                                Fluttertoast.showToast(
                                    msg: '사진을 지우고 다시 선택해주세요.');
                              }
                            },
                            child: images.isEmpty
                                ? _imageUploadButton()
                                : Row(
                                    children: [
                                      _imageUploadButton(),
                                      Row(
                                        children: images
                                            .map(
                                              (e) => Padding(
                                                padding: EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: 72.0,
                                                      height: 72.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8.0,
                                                        ),
                                                        image: DecorationImage(
                                                          image: FileImage(
                                                              File(e.path)),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          removeImage(e);
                                                        },
                                                        child: Icon(
                                                          Icons.cancel_outlined,
                                                          color: Colors.white,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      )
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            '제목',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          CustomTextFormField(
                            controller: _titleController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "제목을 입력해주세요";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (String value) {},
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            '설명',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          CustomTextFormField(
                            controller: _descriptionController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "설명을 입력해주세요";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (String value) {},
                            maxLines: 5,
                            hintText: '사이즈, 대여기간, 사용감 등 상품 설명을 최대한 자세히 적어주세요.',
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            '가격',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          ToggleButtons(
                            children: [Text('월'), Text('주'), Text('일')],
                            isSelected: isSelected,
                            onPressed: toggleSelect,
                            selectedBorderColor: PRIMARY_COLOR,
                            fillColor: Colors.white,
                            selectedColor: Colors.black,
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          CustomTextFormField(
                            controller: _priceController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "가격을 입력해주세요";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (String value) {},
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      CustomButton(
                        onCustomButtonPressed: () {
                          uploadItem();
                        },
                        text: '등록하기',
                        textColor: Colors.white,
                        bgColor: PRIMARY_COLOR,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isUploading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      isMonthSelected = true;
      isWeekSelected = false;
      isDaySelected = false;
      itemRentalPeriodType = ItemRentalPeriodType.month;
    } else if (value == 1) {
      isMonthSelected = false;
      isWeekSelected = true;
      isDaySelected = false;
      itemRentalPeriodType = ItemRentalPeriodType.week;
    } else {
      isMonthSelected = false;
      isWeekSelected = false;
      isDaySelected = true;
      itemRentalPeriodType = ItemRentalPeriodType.day;
    }
    setState(() {
      isSelected = [isMonthSelected, isWeekSelected, isDaySelected];
    });
  }

  Future<void> getImages() async {
    final List<XFile>? pickedFiles =
        await imagePicker.pickMultiImage(limit: 3 - count);
    if (pickedFiles != null) {
      setState(() {
        images.addAll(pickedFiles);
        count = images.length;
      });
    }
  }

  Future<void> getImage() async {
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images.add(pickedFile);
        count = images.length;
      });
    }
  }

  void removeImage(XFile image) {
    setState(() {
      images.remove(image);
      count = images.length;
    });
  }

  Widget _imageUploadButton() {
    return Stack(
      children: [
        Container(
          width: 72.0,
          height: 72.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Color(0xFFD1D1D1)),
          child: Icon(
            Icons.camera_alt_outlined,
            color: Color(0xFF8E8E8E),
          ),
        ),
        Positioned(
          right: 2,
          bottom: 2,
          child: Row(
            children: [
              Text(count.toString()),
              Text('/3'),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> uploadItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isUploading = true;
      });
      final uid = Provider.of<LoginProvider>(context, listen: false).user!.uid;

      final sessionID = DateTime.now().millisecondsSinceEpoch;
      String? thumbUrl;
      String fileRef = "";
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          // XFile 객체를 File 객체로 변환
          File file = File(images[i].path);

          // 파일 경로 설정
          fileRef = "${uid}/${sessionID}/${DateTime.now().millisecondsSinceEpoch}";

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
            } catch(deleteError) {
              print("Failed to delete data from storage");
            }
          }

          // 업로드한 첫 번째 파일의 다운로드 URL 가져오기 -> 썸네일로 사용하기 위해
          if (i == 0) {
            thumbUrl = await storageRef.child(fileRef).getDownloadURL();
          }
        }
      }

      // 물품 데이터
      final item = <String, String>{
        "thumbUrl": thumbUrl ?? "",
        "title": _titleController.text,
        "description": _descriptionController.text,
        "price": _priceController.text,
        "itemRentalPeriodType": itemRentalPeriodType.toString(),
        "uploadTime": DateTime.now().toString(),
        "userID": uid,
        "fileRef": "${uid}/${sessionID}",
      };

      String itemID = DateTime.now().millisecondsSinceEpoch.toString();

      try {
        await FirebaseFirestore.instance
            .collection("items")
            .doc(itemID)
            .set(item);
      } on FirebaseException catch(e) {
        print(e.message);

        // Transaction
        // DB에서 업로드된 데이터 삭제
        try {
          await FirebaseFirestore.instance.collection("itmes").doc(itemID).delete();
        } catch(deleteError) {
          print("Failed to delete data from DB");

          Fluttertoast.showToast(msg: "업로드 실패. 네트워크를 확인해주세요.");
        }
      }
      isUploading = false;
      Fluttertoast.showToast(msg: "업로드 성공!");
      Navigator.of(context).pop(); // 다시 홈 화면으로 이동
    }
  }
}
