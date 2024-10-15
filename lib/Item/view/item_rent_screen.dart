import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unitory_project/Item/model/item_model.dart';
import 'package:unitory_project/common/component/custom_button.dart';
import 'package:unitory_project/common/component/custom_text_form_field.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';

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

  @override
  void initState() {
    isSelected = [isMonthSelected, isWeekSelected, isDaySelected];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "",
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                        if(count != 3) {
                          count == 2 ? getImage() : getImages();
                        } else {
                          Fluttertoast.showToast(msg: '사진을 지우고 다시 선택해주세요.');
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
                                                      BorderRadius.circular(
                                                    8.0,
                                                  ),
                                                  image: DecorationImage(
                                                    image:
                                                        FileImage(File(e.path)),
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
                      onChanged: (String value) {},
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.0,
                ),
                CustomButton(
                  text: '등록하기',
                  textColor: Colors.white,
                  bgColor: PRIMARY_COLOR,
                )
              ],
            ),
          ),
        ),
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
    final List<XFile>? pickedFiles = await imagePicker.pickMultiImage(limit: 3 - count);
    if (pickedFiles != null) {
      setState(() {
        images.addAll(pickedFiles);
        count = images.length;
      });
    }
  }

  Future<void> getImage() async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
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
}
