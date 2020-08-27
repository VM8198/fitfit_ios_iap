import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_fitfit/api/auth_repo.dart';
import 'package:flutter_fitfit/model/auth_model.dart';
import 'package:flutter_fitfit/model/user_model.dart';
import 'package:flutter_fitfit/utility/pref.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

class AuthProvider with ChangeNotifier {
  
  AuthRepository _authRepo;
  AuthModel _authModel = AuthModel();
  UserModel _userModel = UserModel();
  bool _isLoading = false;
  bool _hasError = false;
  String _errorType;
  String _errorMsg;

  AuthProvider() {
    _authRepo = new AuthRepository();
    _init();
  }

  _init() async {
    String token = await Pref.getToken();

    // no need get other info if there is no token, as user is not login yet
    if (token == null) {
      return ;
    }

    String userId = await Pref.getUserId();

    _userModel = new UserModel(
      id: userId,
      token: token,
    );

    notifyListeners();
  }

  get isLoggedIn => _userModel.token != null;

  set email(String email) {
    _authModel.email = email;
    notifyListeners();
  }

  get email => _authModel.email;

  set password(String password) {
    _authModel.password = password;
    notifyListeners();
  }

  get password => _authModel.password;

  get isLoading => _isLoading;

  set isLoading(bool flag) {
    _isLoading = flag;
    notifyListeners();
  }

  get hasError => _hasError;

  get errorType => _errorType;

  get errorMsg => _errorMsg;

  get quesCompleted => _userModel.quesCompleted;

  get isVerified => _userModel.isVerified;

  set isVerified(bool verified) {
    _userModel.isVerified = verified;
  }

  get verificationCode => _authModel.verificationCode;

  set verificationCode(int code) {
    _authModel.verificationCode = code;
    notifyListeners();
  }

  toggleLoading() => isLoading = !isLoading;

  reset() {
    _hasError = false;
    _errorType = null;
    _errorMsg = null;
    
  }

  clear() {
    _userModel = UserModel();
    Pref.clear();
  }

  resetAuthModel() {
    _authModel = AuthModel();
  }

  login() async {
    if (isLoading) return; // avoid mutiple call
    reset();
    toggleLoading();
    dynamic results = await _authRepo.login(_authModel);
    toggleLoading();

    if (results['success'] == false) {
      _setError(results);
      return false;
    }
    
    _userModel = UserModel.fromJson(results['data']);

    _setupPref(_userModel);

    notifyListeners();

    return true;
  }

  Future<bool> loginApple() async{
    if (isLoading) return false;

    final AuthorizationResult results = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
     
    

    if (results.status == AuthorizationStatus.error || results.status == AuthorizationStatus.cancelled) {
      var results = {'error_code': '403', 'message': 'Something went wrong, please try again.'};
      _setError(results);
      return false;
    }

    toggleLoading();
    var fullNameData = results.credential.fullName;
    _authModel.name = '${fullNameData.familyName} ${fullNameData.givenName}';
    _authModel.appleAccessToken = String.fromCharCodes(results.credential.identityToken);

    var loginResults = await _authRepo.appleLogin(_authModel);

    toggleLoading();
    
    if (loginResults['success'] == false) {
      _setError(loginResults);
      return false;
    }

    _userModel = UserModel.fromJson(loginResults['data']);

    _setupPref(_userModel);

    notifyListeners();

    return true;
  }

  Future<bool> loginFb() async{
    if (isLoading) return null; // avoid mutiple call
    toggleLoading();
    FacebookLogin fbLogin = FacebookLogin();
    await fbLogin.logOut();
    FacebookLoginResult fbLoginResult = await fbLogin.logIn(['email']);

    if (fbLoginResult.status != FacebookLoginStatus.loggedIn || fbLoginResult.accessToken == null) {
      toggleLoading();
      var results = {'error_code': '403', 'message': 'Something went wrong, please try again.'};
      _setError(results);
      return false;
    }

    _authModel.fbAccessToken = fbLoginResult.accessToken.token;
    var results = await _authRepo.fbLogin(_authModel);
    
    toggleLoading();

    if (results['success'] == false) {
      _setError(results);
      return false;
    }

    _userModel = UserModel.fromJson(results['data']);

    _setupPref(_userModel);

    notifyListeners();

    return true;
  }

  _setupPref(UserModel userModel) {
    Pref.setToken(_userModel.token);
    Pref.setUserId(_userModel.id);
    Pref.setIsVerified(_userModel.isVerified);
    Pref.setQuesCompleted(_userModel.quesCompleted);
    Pref.setUserEmail(_userModel.email);
  }

  _setError(results) {
    _hasError = true;
    _errorType = results['error_code'];
    _errorMsg = results['message'];
  }


  signUp() async {
    if (isLoading) return; // avoid mutiple call
    reset();
    toggleLoading();
    dynamic results = await _authRepo.signUp(_authModel);
    toggleLoading();

    if (results['success'] == false) {
      _setError(results);
      return false;
    }

    _userModel = UserModel.fromJson(results);
    _setupPref(_userModel);

    notifyListeners();

    return true;
  }


  submitVerificationCode() async {
    if (isLoading) return; // avoid mutiple call
    reset();
    toggleLoading();
    _authModel.custId = await Pref.getUserId();

    dynamic results = await _authRepo.verifyCode(_authModel);
    toggleLoading();

    if (results['success'] == false) {
      _setError(results);
      return false;
    }

    isVerified = true;
    Pref.setIsVerified(true);

    notifyListeners();

    return true;
  }


  resendVerificationCode() async {
    if (isLoading) return; // avoid mutiple call
    reset();
    toggleLoading();
    _authModel.custId = await Pref.getUserId();

    dynamic results = await _authRepo.resendVerifyCode(_authModel);
    toggleLoading();

    if (results['success'] == false) {
      _setError(results);
      return false;
    }

    return true;
  }

}