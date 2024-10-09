import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitory_project/common/const/colors.dart';
import 'package:unitory_project/common/layout/default_layout.dart';
import 'package:unitory_project/common/view/root_tab.dart';
import 'package:unitory_project/providers/login_provider.dart';
import 'package:unitory_project/user/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderLogoText(),
              SizedBox(
                height: 16.0,
              ),
              CircularProgressIndicator(
                color: PRIMARY_COLOR,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderLogoText() {
    return Column(
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
    );
  }

  Future<void> _initialize() async {
    await Future.delayed(Duration(seconds: 1));
    context.read<LoginProvider>().currentUser(); // listen: false 할 필요 없음
    User? user = context.read<LoginProvider>().user;
    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RootTab(),
        ),
      );
    }
  }
}
