import 'package:flutter/material.dart';
import 'package:unitory_project/common/component/custom_button.dart';
import 'package:unitory_project/common/component/custom_text_form_field.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';

class ItemRentScreen extends StatelessWidget {
  const ItemRentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "",
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
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
                    SizedBox(height: 8.0,),
                    Container(
                      width: 72.0,
                      height: 72.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0xFFD1D1D1)
                      ),
                      child: Icon(Icons.camera_alt_outlined, color: Color(0xFF8E8E8E),),
                    ),
                    SizedBox(height: 16.0,),
                    Text('제목', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),),
                    CustomTextFormField(onChanged: (String value) {}),
                    SizedBox(height: 16.0,),
                    Text('설명', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),),
                    CustomTextFormField(onChanged: (String value) {}),
                    SizedBox(height: 16.0,),
                    Text('가격', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),),
                    CustomTextFormField(onChanged: (String value) {}),
                  ],
                ),
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
    );
  }
}
