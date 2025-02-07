

class User {
  int id = 0;
  String email = "";
  String profileImageThumb = "";
  String password = "";
  String code = "";
  String deviceToken = "";
  String accessToken = "";
  String deviceType = "";
  String emailVerifiedAt = "";
  bool isEmailVerified = false;
  String username = "";
  String firstName = "";
  String lastName = "";
  String dob = "";
  String phoneNumber = "";
  String type = "";
  String emailVerificationSentAt = "";
  String wallet = "";

  User();

  User.fromMap(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] ?? 0;
      email = jsonMap['email'] ?? '';
      profileImageThumb = jsonMap['userImageThumb'] ?? '';
      emailVerifiedAt = jsonMap['email_verified_at'] ?? '';
      isEmailVerified = jsonMap['isEmailVerified'] ?? false;
      accessToken = jsonMap['accessToken'] ?? '';
      username = jsonMap['username'] ?? '';
      firstName = jsonMap['firstName'] ?? '';
      lastName = jsonMap['lastName'] ?? '';
      dob = jsonMap['DOB'] ?? '';
      phoneNumber = jsonMap['phoneNumber'] ?? '';
      code = jsonMap['code'] ?? '';
      type = jsonMap['type'] ?? '';
      emailVerificationSentAt = jsonMap['email_verification_sent_at'] ?? '';
      wallet = jsonMap['wallet'] ?? '';
    } catch (e) {
      print(e);
    }
  }

  Map<String, String> toMap() {
    var map = <String, String>{};
    map["password"] = password ?? '';
    map["email"] = email ?? '';
    map["deviceToken"] = deviceToken ?? '';
    map["accessToken"] = accessToken ?? '';
    map["type"] = type ?? '';
    map["username"] = username ?? '';
    map["phoneNumber"] = phoneNumber ?? '';
    map["firstName"] = firstName ?? '';
    map["lastName"] = lastName ?? '';
    map["DOB"] = dob ?? '';
    return map;
  }

  Map<String, dynamic> toCloneMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["password"] = password ?? '';
    map["email"] = email ?? '';
    map["userImageOrginal"] = profileImageThumb ?? '';
    map["deviceToken"] = deviceToken ?? '';
    map["accessToken"] = accessToken ?? '';
    return map;
  }

  Map<String, dynamic> toCreateAccountMap() {
    var map = <String, dynamic>{};
    map["email"] = email;
    map["password"] = password;
    return map;
  }
}
