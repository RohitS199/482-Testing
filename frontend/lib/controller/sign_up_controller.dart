import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  String? _name;
  String? get name => _name;
  void setName(String? text) {
    _name = text;
    debugPrint("Updated name: $name");
    update();
  }

  String? _email;
  String? get email => _email;
  void setEmail(String? text) {
    _email = text;
    update();
  }

  String? _username;
  String? get username => _username;
  void setUsername(String? text) {
    _username = text;
    update();
  }

  String? _password;
  String? get password => _password;
  void setPassword(String? text) {
    _password = text;
    update();
  }

  String? _phoneNumber;
  String? get mobileNumber => _phoneNumber;
  void setMobileNumber(String? text) {
    _phoneNumber = text;
    update();
  }

// [type] registerUser(String email, String password) async {
  // send User info to database and populate
// }
}
