import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _currentUser;

  final Map<String, Map<String, String>> _dummyUsers = {
    "John": {
      "email": "john@example.com",
      "password": "123456",
    },
    "Alice": {
      "email": "alice@example.com",
      "password": "123456",
    },
    "Bob": {
      "email": "bob@example.com",
      "password": "123456",
    },
  };

  String? get currentUser => _currentUser;

  Map<String, Map<String, String>> get dummyUsers => _dummyUsers;

  bool login(String email, String password) {
    try {
      final userEntry = _dummyUsers.entries.firstWhere(
            (entry) =>
        entry.value["email"] == email &&
            entry.value["password"] == password,
      );

      _currentUser = userEntry.key;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
