import 'package:flower_app/model/user.dart';
import 'package:flutter/material.dart';

class LocalUserProfile with ChangeNotifier {
  String fullName = '';
  String email = '';
  String avatarUrl = '';
  String role = '';

  set(LocalUser user) {
    fullName = user.fullName;
    email = user.email;
    avatarUrl = user.avatarUrl;
    role = user.role;
    notifyListeners();
  }

  // reset() {
  //   user = LocalUser(fullName: '', email: '', avatarUrl: '', role: '');
  //   notifyListeners();
  // }

  // get _user {
  //   return user;
  // }
}
