class UserModel {
  String id;
  String token;
  bool isVerified;
  bool quesCompleted;
  String email;

  UserModel({
    this.id,
    this.token,
    this.isVerified,
    this.quesCompleted,
    this.email
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['cust_id'] ?? null;
    token = json['token'] ?? null;
    isVerified = json['is_verified'] ?? false;
    quesCompleted = json['ques_completed'] ?? false;
    email = json['email'] ?? null;
  }
}