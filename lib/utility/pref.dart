import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static const _token = 'token';
  static const _userId = 'user_id';
  static const _userEmail = 'user_email';
  static const _isVerified = 'is_verified';
  static const _quesCompleted = 'ques_completed';
  
  static Future<bool> setToken(token) {
    return _setString(_token, token);
  }

  static Future<String> getToken() {
    return _getString(_token);
  }
  
  static Future<bool> setUserId(userId) {
    return _setString(_userId, userId);
  }

  static Future<String> getUserId() {
    return _getString(_userId);
  }

  static Future<bool> setUserEmail(userEmail) {
    return _setString(_userEmail, userEmail);
  }

  static Future<String> getUserEmail() {
    return _getString(_userEmail);
  }

  static Future<bool> setIsVerified(userId) {
    return _setBool(_isVerified, userId);
  }

  static Future<bool> setQuesCompleted(completed) {
    return _setBool(_quesCompleted, completed);
  }

  static Future<bool> getQuesCompleted() {
    return _getBool(_quesCompleted);
  }
  
  // below are internal helper function
  static Future<SharedPreferences> _getInstance() async{
    return SharedPreferences.getInstance();
  }

  static Future<String> _getString(key) async{
    return (await _getInstance()).getString(key);
  }
  
  static Future<bool> _setString(key, value) async{
    return (await _getInstance()).setString(key, value);
  }

  static Future<bool> _getBool(key) async{
    return (await _getInstance()).getBool(key);
  }

  static Future<bool> _setBool(key, value) async{
    return (await _getInstance()).setBool(key, value);
  }

  static Future<bool> clear() async{
    return (await _getInstance()).clear();
  }
}