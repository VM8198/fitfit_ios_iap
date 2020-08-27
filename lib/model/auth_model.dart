class AuthModel {
  String email;
  String password;
  String fbAccessToken;
  String appleAccessToken;
  String custId;
  String name;
  int verificationCode;

  AuthModel({
    this.email,
    this.password,
    this.fbAccessToken,
    this.appleAccessToken,
    this.custId,
    this.verificationCode,
    this.name,
  });

  toLoginReq() {
    return {
      "email": email,
      "password": password,
    };
  }

  toFbLoginReq() {
    return {
      "access_token": fbAccessToken,
    };
  }

  toAppleLoginReq() {
    return {
      "name": name,
      "token": appleAccessToken
    };
  }

  toSignUpReq() {
    return {
      "email": email,
      "password": password,
    };
  }

  toVerifyCodeReq() {
    return {
      "cust_id": custId,
      "verification_code": verificationCode
    };
  }

  toResendVerifyCodeReq() {
    return {
      "cust_id": custId,
    };
  }
}