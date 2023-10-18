class UserBean {
  int? id;
  String? name;
  String? email;
  int? regType;
  String? password;

  UserBean({this.id, this.name,  this.email, this.regType, this.password});

  UserBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    regType = json['login_type'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['reg_type'] = this.regType;
    data['password'] = this.password;
    return data;
  }
}
