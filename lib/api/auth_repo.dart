import 'package:flutter_fitfit/api/repo.dart';
import 'package:flutter_fitfit/model/auth_model.dart';

class AuthRepository extends Repository{
  login(AuthModel model) {
    return api.post('/login', model.toLoginReq());
  }

  fbLogin(AuthModel model) {
    return api.post('/login/social/fb', model.toFbLoginReq());
  }

  appleLogin(AuthModel model) {
    return api.post('/login/social/apple', model.toAppleLoginReq());
  }

  signUp(AuthModel model) {
    return api.post('/register', model.toSignUpReq());
  }

  verifyCode(AuthModel model) {
    return api.post('/password/verify', model.toVerifyCodeReq());
  }

  resendVerifyCode(AuthModel model) {
    return api.post('/password/resend', model.toResendVerifyCodeReq());
  }
}