import 'package:flutter/material.dart';
import 'package:unitory_project/common/const/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _renderLogoText(),
            _CustomButton(
              text: '유세인트 로그인',
              textColor: Colors.white,
              bgColor: PRIMARY_COLOR,
            ),
            const SizedBox(
              height: 8.0,
            ),
            _CustomButton(
              text: 'Google 로그인',
              textColor: BODY_TEXT_COLOR,
            ),
            const SizedBox(
              height: 16.0,
            )
          ],
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

class _CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color? bgColor;

  const _CustomButton(
      {super.key, required this.text, required this.textColor, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          12.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
