import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _username = '';

  bool get isAuthenticated => _isAuthenticated;
  String get username => _username;

  Future<bool> login(String username, String password) async {
    // Validar credenciales (admin:admin)
    if (username == 'admin' && password == 'admin') {
      _isAuthenticated = true;
      _username = 'Admin';
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _username = '';
    notifyListeners();
  }
}
