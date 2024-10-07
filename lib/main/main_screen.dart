import 'package:flutter/material.dart';
import 'package:unitory_project/common/layout/default_layout.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: Center(
          child: Text('Main Screen'),
        ),
      ),
    );
  }
}
