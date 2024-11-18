import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitory_project/common/view/splash_screen.dart';
import 'package:unitory_project/providers/add_to_favorite_provider.dart';
import 'package:unitory_project/providers/indicator_provider.dart';
import 'package:unitory_project/providers/login_provider.dart';
import 'package:unitory_project/user/view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => IndicatorProvider()),
        ChangeNotifierProvider(create: (_) => AddToFavoriteProvider()),
      ],
      child: const _App(),
    ),
  );
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Pretendard"
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
