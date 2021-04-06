import 'package:flutter/material.dart';
import 'package:refuelings_collector/models/user.dart';
import 'package:refuelings_collector/services/api_requester.dart';

class CurrentUser extends ChangeNotifier {
  String _email;
  bool _isLoading = false;

  String get email => _email;
  bool get isLoading => _isLoading;

  Future<bool> signInUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    bool retVal = false;

    try {
      User user = await ApiRequester().attemptSignIn(email, password);
      if (user != null) {
        _email = user.email;
        retVal = true;
      }
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();

    return retVal;
  }

  Future signOutUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiRequester().signOut();
      _email = null;
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> hasValidToken() async {
    bool retVal = false;

    try {
      User user = await ApiRequester().validateToken();
      if (user != null) {
        _email = user.email;
        retVal = true;
      }
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
