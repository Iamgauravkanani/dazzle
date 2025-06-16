import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefsHelper {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _authTokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _businessNameKey = 'business_name';
  static const String _cityKey = 'city';
  static const String _stateKey = 'state';
  static const String _businessTypeKey = 'business_type';

  static Future<void> saveUserData({
    required String uid,
    required String email,
    required String firstName,
    required String businessName,
    required String city,
    required String state,
    required String businessType,
    String? authToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    final userData = {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'businessName': businessName,
      'city': city,
      'state': state,
      'businessType': businessType,
    };

    await prefs.setString(_userKey, jsonEncode(userData));
    await prefs.setBool(_isLoggedInKey, true);
    if (authToken != null) {
      await prefs.setString(_authTokenKey, authToken);
    }
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, firstName);
    await prefs.setString(_businessNameKey, businessName);
    await prefs.setString(_cityKey, city);
    await prefs.setString(_stateKey, state);
    await prefs.setString(_businessTypeKey, businessType);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_authTokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_businessNameKey);
    await prefs.remove(_cityKey);
    await prefs.remove(_stateKey);
    await prefs.remove(_businessTypeKey);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getBusinessName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_businessNameKey);
  }

  static Future<String?> getCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cityKey);
  }

  static Future<String?> getState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_stateKey);
  }

  static Future<String?> getBusinessType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_businessTypeKey);
  }
} 