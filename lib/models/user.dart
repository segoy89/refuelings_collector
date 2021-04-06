import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.email,
    this.provider,
    this.uid,
    this.name,
    this.admin,
    this.themeColor,
  });

  int id;
  String email;
  String provider;
  String uid;
  String name;
  bool admin;
  String themeColor;

  factory User.fromJson(Map<String, dynamic> json) {
    json = json['data'];
    return User(
      id: json["id"],
      email: json["email"],
      provider: json["provider"],
      uid: json["uid"],
      name: json["name"],
      admin: json["admin"],
      themeColor: json["theme_color"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "provider": provider,
    "uid": uid,
    "name": name,
    "admin": admin,
    "theme_color": themeColor,
  };
}
