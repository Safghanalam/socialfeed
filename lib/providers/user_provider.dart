import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _currentUser = "Alice";

  String get currentUser => _currentUser;

  void login(String username) {
    _currentUser = username;
    notifyListeners();
  }
}
