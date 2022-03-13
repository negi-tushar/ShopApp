import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/global.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _myTimer;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<String> _authenticate(
      String email, String password, String action) async {
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$action?key=$key');

    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final responseData = json.decode(response.body);
    //print('Response data is $responseData');
    if (responseData['error'] != null) {
      print('my error');
      return (responseData['error']['message']);
    }

    // print(responseData);

    //setting values again to use it in API call

    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate = DateTime.now()
        .add(Duration(seconds: int.parse(responseData['expiresIn'])));
    // print(_expiryDate);
    _autoLogout();
    notifyListeners();

    //storing data to local devise to auto Login

    final pref = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate?.toIso8601String(),
    });
    pref.setString('userData', userData);

    return 'Authenticate Success';
  }

  Future<bool> autoAuthenticate() async {
    final prefs = await SharedPreferences.getInstance();
    // print('in autoLogin');
    if (!prefs.containsKey('userData')) {
      return false;
    }
    //print('in autoLogin 2');
    final fetchedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(fetchedData['expiryDate']);
    //print('expiryDate $expiryDate');
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    //print('in autoLogin 3');
    //setting values again to use it in API call
    _token = fetchedData['token'];
    _userId = fetchedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();

    _autoLogout();
    // print('token $_token');
    return true;
  }

  Future<String> signUp(String email, String password) async {
    // try {

    // } on HttpException catch (e) {
    //   print('got error');
    // }
    print('signup call');
    var response = await _authenticate(email, password, 'signUp');
    return response;
  }

  Future<String> login(String email, String password) async {
    var response = await _authenticate(email, password, 'signInWithPassword');
    return response;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_myTimer != null) {
      _myTimer?.cancel();
      _myTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void _autoLogout() {
    if (_myTimer != null) {
      _myTimer?.cancel();
    }

    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _myTimer = Timer(Duration(seconds: timeToExpiry!), logout);
    // print(timeToExpiry);
  }
}
