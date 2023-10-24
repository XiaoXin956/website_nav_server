import 'package:mysql1/mysql1.dart';

import '../bean/result_bean.dart';
import '../bean/user_bean.dart';
import '../db_utils.dart';

abstract class IUserRepository {
  Future<dynamic> userReg(dynamic map);

  Future<dynamic> userUpdate(dynamic map);

  Future<dynamic> userSearch(dynamic map);
}

class UserRepository extends IUserRepository {
  @override
  Future<dynamic> userReg(map) async {
    ResultBean resultBean = ResultBean();
    if (map["email"].isEmpty) {
      resultBean.msg = "邮箱不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    if (map["password"].isEmpty) {
      resultBean.msg = "密码不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    // 先查询
    var queryUserCount = await db.query("select * from user where email ='${map['email']}'");
    for (var value in queryUserCount) {
      resultBean.msg = "该邮箱已存在";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    db.query("insert into user (name,reg_type,password,email) values(?,?,?,?)", [
      map['name'],
      map['reg_type'],
      map['password'],
      map['email'],
    ]);
    await Future.delayed(Duration(seconds: 2));
    var queryUserDetails = await db.query("select * from user where email ='${map['email']}'");
    UserBean? userBean;
    for (var row in queryUserDetails) {
      userBean = UserBean(id: row['id'], name: row['name'], email: row['email'], regType: row['reg_type'], authority: row['authority']);
      print('注册信息：${userBean.toJson()} ');
    }
    resultBean.code = 0;
    resultBean.msg = "注册成功";
    resultBean.data = userBean?.toJson();
    return resultBean.toJson();
  }

  @override
  Future<dynamic> userSearch(map) async {
    ResultBean resultBean = ResultBean();
    if (map["email"].isEmpty) {
      resultBean.msg = "邮箱不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    if (map["password"].isEmpty) {
      resultBean.msg = "密码不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    var queryUserDetails = await db.query("select * from user where email =${map['email']} and password=${map['password']}");
    UserBean? userBean;
    for (var row in queryUserDetails) {
      userBean = UserBean(id: row['id'], name: row['name'], email: row['email'], regType: row['reg_type'], authority: row['authority']);
      print('登录信息：${userBean.toJson()} ');
    }
    if (userBean == null) {
      resultBean.code = -1;
      resultBean.msg = "账号或密码错误";
    } else {
      resultBean.code = 0;
      resultBean.msg = "登录成功";
      resultBean.data = userBean.toJson();
    }
    return resultBean.toJson();
  }

  @override
  Future<dynamic> userUpdate(map) async {
    ResultBean resultBean = ResultBean();
    if (map['name'].toString().isEmpty) {
      resultBean.msg = "名称不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    // 先查询是否存在
    var queryTypeCount = await db.query("select * from user where id =${map['id']}");
    if (queryTypeCount.fields.isEmpty) {
      resultBean.msg = "无此数据";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    await db.query('update user set name=?,email=?,password=? where id=?', [map['name'], map['email'], map['password'], map['id']]);
    var queryType = await db.query("select * from user where id =${map['id']}");
    UserBean? userBean;
    for (var row in queryType) {
      userBean = UserBean(id: row['id'], name: row['name'], email: row['email'], regType: row['reg_type'], authority: row['authority']);
    }
    resultBean.msg = "修改成功,即将退出";
    resultBean.code = 0;
    resultBean.data = userBean?.toJson();
    return resultBean.toJson();
  }
}
