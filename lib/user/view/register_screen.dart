import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitory_project/common/layout/default_layout.dart';
import 'package:unitory_project/user/view/login_success_screen.dart';

import '../../common/component/custom_button.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

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
                '회원가입',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 80.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value.isEmpty) {
                          // null과 isEmpty는 다름!
                          return '이메일을 입력해주세요';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (data) {},
                      hintText: '이메일을 입력해주세요',
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    CustomTextFormField(
                      controller: _pwController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (data) {},
                      hintText: '비밀번호를 입력해주세요',
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    CustomTextFormField(
                      controller: _confirmPwController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '비밀번호를 확인해주세요';
                        } else if (value != _pwController.text) {
                          return '비밀번호가 일치하지 않아요';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (data) {},
                      hintText: '비밀번호를 확인해주세요',
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        signUp();
                      },
                      child: CustomButton(
                        text: '회원가입',
                        textColor: Colors.white,
                        bgColor: PRIMARY_COLOR,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
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

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _pwController.text,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LoginSuccessScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
