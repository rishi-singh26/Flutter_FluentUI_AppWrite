class UserFields {
  static const String id = "\$id";
  static const String name = "name";
  static const String email = "email";
  static const String registrationDate = "registration";
  static const String roles = "roles";
}

class User {
  final String id;
  final String email;
  final int registration;
  final String name;
  final List<String> roles;

  const User({
    required this.id,
    required this.email,
    required this.registration,
    required this.name,
    required this.roles,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json[UserFields.id],
        email = json[UserFields.email],
        registration = json[UserFields.registrationDate],
        name = json[UserFields.name],
        roles = json[UserFields.roles].cast<String>();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[UserFields.id] = id;
    data[UserFields.email] = email;
    data[UserFields.registrationDate] = registration;
    data[UserFields.name] = name;
    data[UserFields.roles] = roles;
    return data;
  }
}
