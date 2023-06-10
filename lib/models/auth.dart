import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  static const _url =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCxtMOqVBUeWc5N0PxFel7YIP7uIEElf_E";

  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuth {
    bool isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get uid {
    return isAuth ? _uid : null;
  }

  Future<void> _autheticate(
      String email, String password, String urlFragment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyCxtMOqVBUeWc5N0PxFel7YIP7uIEElf_E";
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _uid = body['localId'];

      _expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));


      Store.saveMap('userData',{
        'token':  _token,
        'email' : _email,
        'userId' : _uid,
        'expiryDate' : _expiryDate!.toIso8601String()
      });

      notifyListeners();
      _autoLogout();
    }
  }

  Future<void> signup(String email, String password) async {
    return _autheticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _autheticate(email, password, "signInWithPassword");
  }

  void logout() {
    _token = null;
    _email = null;
    _uid = null;
    _expiryDate = null;
    Store.remove('userData').then((_) => notifyListeners());
  }

  void _clearLogouTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogouTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }

  Future<void> tryAutoLogin() async{
    if(isAuth) return;

    final userData = await Store.getMap('userData');
    if(userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _uid = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();

  }
}
