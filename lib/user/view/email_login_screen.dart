import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitory_project/common/component/custom_button.dart';
import 'package:unitory_project/common/component/custom_text_form_field.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';
import 'package:unitory_project/main/main_screen.dart';
import 'package:unitory_project/user/view/register_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      onChanged: (String value) {},
                      hintText: '이메일을 입력해주세요',
                      controller: _emailController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '이메일을 입력해주세요';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    CustomTextFormField(
                      onChanged: (String value) {},
                      hintText: '비밀번호를 입력해주세요',
                      obscureText: true,
                      controller: _pwController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: _onLoginButtonTap,
                      child: CustomButton(
                        text: '로그인',
                        textColor: Colors.white,
                        bgColor: PRIMARY_COLOR,
                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onLoginButtonTap() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text, password: _pwController.text);

        if (credential.user!.emailVerified) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MainScreen(),
            ),
          );
        } else {
          // 인증 메일 재발송을 너무 자주 하지 않도록 예외 처리 추가
          try {
            await credential.user!.sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('인증 메일을 다시 확인해주세요!'),
              ),
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'too-many-requests') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.'),
                ),
              );
            } else {
              print(e);
            }
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
