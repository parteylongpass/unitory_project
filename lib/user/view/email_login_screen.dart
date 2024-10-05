import 'package:flutter/material.dart';
import 'package:unitory_project/common/component/custom_button.dart';
import 'package:unitory_project/common/component/custom_text_form_field.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';
import 'package:unitory_project/user/view/register_screen.dart';

class EmailLoginScreen extends StatelessWidget {
  String email = "";
  String password = "";

  EmailLoginScreen({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 48.0,
              ),
              Text(
                '이메일로 로그인',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 96.0,
              ),
              Column(
                children: [
                  CustomTextFormField(
                    onChanged: (String value) {},
                    hintText: '이메일을 입력해주세요',
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  CustomTextFormField(
                    onChanged: (String value) {},
                    hintText: '비밀번호를 입력해주세요',
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomButton(
                    text: '로그인',
                    textColor: Colors.white,
                    bgColor: PRIMARY_COLOR,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '혹시 회원이 아니신가요?  ',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            color: BODY_TEXT_COLOR,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
