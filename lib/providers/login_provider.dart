import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  User? _user;

  User? get user => _user; // user는 getter의 이름

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _user = credential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e); // 실제 예외처리는 여기서 하지 않음
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut(); // FirebaseAuth.instance -> static getter
    _user = null;
    notifyListeners();
  }

  void currentUser() {
    _user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자의 정보를 리턴
    notifyListeners();
  }
}
