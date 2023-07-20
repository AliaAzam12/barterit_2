class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? datereg;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.phone,
      required this.datereg});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    datereg = json['datereg'];

  }
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    user['id'] = id;
    user['email'] = email;
    user['name'] = name;
    user['password'] = password;
    user['phone'] = phone;
    user['datereg'] = datereg;
    return user;
  }
  }