import 'package:flutter/material.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';
import 'package:unitory_project/user/view/email_login_screen.dart';

import '../../common/component/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _renderLogoText(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EmailLoginScreen(),
                    ),
                  );
                },
                child: CustomButton(
                  text: '이메일로 로그인',
                  textColor: Colors.white,
                  bgColor: PRIMARY_COLOR,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomButton(
                text: 'Google로 로그인',
                textColor: BODY_TEXT_COLOR,
              ),
              const SizedBox(
                height: 16.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderLogoText() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'asset/img/unitory_logo.png',
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            'UNITORY',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
