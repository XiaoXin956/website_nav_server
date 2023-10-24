class UserBean {
  int? id;
  String? name;
  String? email;
  int? regType;
  String? password;
  int? authority;

  UserBean({this.id, this.name,  this.email, this.regType, this.password, this.authority});

  UserBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    regType = json['login_type'];
    password = json['password'];
    authority = json['authority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['reg_type'] = this.regType;
    data['password'] = this.password;
    data['authority'] = this.authority;
    return data;
  }
}
