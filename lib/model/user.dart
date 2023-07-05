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
    final Map<String, dynamic> user = new Map<String, dynamic>();
    user['id'] = this.id;
    user['email'] = this.email;
    user['name'] = this.name;
    user['password'] = this.password;
    user['phone'] = this.phone;
    user['datereg'] = this.datereg;
    return user;
  }
  }