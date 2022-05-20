import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? token;

  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController mobileNo = TextEditingController();

  Future<bool> signIn() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> signUp() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
