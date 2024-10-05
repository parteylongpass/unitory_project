import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unitory_project/common/layout/default_layout.dart';
import 'package:unitory_project/user/view/email_login_screen.dart';
import 'package:unitory_project/user/view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
