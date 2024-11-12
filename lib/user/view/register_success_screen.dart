import 'package:flutter/material.dart';
import 'package:unitory_project/common/component/custom_button.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';

class RegisterSuccessScreen extends StatelessWidget {
  final String email;

  const RegisterSuccessScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: SafeArea(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 124.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 36.0,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${email}으로',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '인증 메일이 발송되었어요!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    '인증 메일이 확인되어야 정상적으로 회원가입이 완료됩니다.',
                    style: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 4.0,),
                  Text(
                    '*혹시 메일이 도착하지 않았다면 스팸함을 확인해주세요.',
                    style: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 72.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.0,
                ),
                child: CustomButton(
                  onCustomButtonPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  text: '처음으로 돌아가기',
                  textColor: Colors.white,
                  bgColor: PRIMARY_COLOR,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
