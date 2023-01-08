import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/Widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(email, password, type) async {
    try {
      Uri url = Uri.https('identitytoolkit.googleapis.com',
          '/v1/accounts:$type', {'key': 'your flutter project api key'});
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final storedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;

    final expiryDate = DateTime.parse(storedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    } else {
      _token = storedUserData['token'];
      _userId = storedUserData['userId'];
      _expiryDate = expiryDate;
      notifyListeners();
      autoLogout();
      return true;
    }
  }

  Future<void> signUp(email, password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(email, password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExp = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExp), logout);
  }
}
