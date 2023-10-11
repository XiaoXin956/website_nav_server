// 导航类型
import 'dart:convert';

import 'package:mysql1/mysql1.dart';

import '../bean/result_bean.dart';
import '../bean/type_bean.dart';
import '../db_utils.dart';

class TypeRepository {
  // 添加
  Future<dynamic> addType(String name) async {
    ResultBean resultBean = ResultBean();
    if (name.isEmpty) {
      resultBean.msg = "类型不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    var query = db.query("insert into type (name) values(?)", [name]);
    print(query);
    resultBean.msg = "添加成功";
    resultBean.code = 0;
    return resultBean.toJson();
  }

  // 查询
  Future<dynamic> searchType(dynamic map) async {
    ResultBean resultBean = ResultBean();
    MySqlConnection db = await DbUtils.instance();
    String searchSql = "";
    if (map["id"] != null) {
      searchSql = "select * from type where id =${map["id"]}";
    } else {
      searchSql = "select * from type where name like '%${map["name"]??''}%'";
    }
    var queryType = await db.query(searchSql);
    List<TypeBean> typeBeans = [];
    for (var row in queryType) {
      print('id: ${row[0]}, name: ${row[1]} ');
      TypeBean typeBean = TypeBean(id: row[0], name: row[1]);
      typeBeans.add(typeBean);
    }
    resultBean.msg = "查询成功";
    resultBean.code = 0;
    resultBean.data = json.encode(typeBeans);
    return resultBean.toJson();
  }

  // 更新
  Future<dynamic> updateType(dynamic map) async {
    ResultBean resultBean = ResultBean();
    if (map['id'].toString().isEmpty || map['name'].toString().isEmpty) {
      resultBean.msg = "参数不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    // 先查询是否存在
    var queryTypeCount = await db.query("select * from type where id =${map['id']}");
    if (queryTypeCount.fields.isEmpty) {
      resultBean.msg = "暂无此数据";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    await db.query('update type set name=? where id=?', [map['name'], map['id']]);
    var queryType = await db.query("select * from type where id =${map['id']}");
    TypeBean? typeBean;
    for (var row in queryType) {
      print('id: ${row[0]}, name: ${row[1]} ');
      typeBean = TypeBean(id: row[0], name: row[1]);
    }
    resultBean.msg = "修改成功";
    resultBean.code = 0;
    resultBean.data = typeBean!.toJson();
    return resultBean.toJson();
  }

  // 修改
  Future<dynamic> delType(dynamic map) async {
    ResultBean resultBean = ResultBean();
    if (map['id'].toString().isEmpty) {
      resultBean.msg = "参数不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    String searchSql = "";
    if (map["id"] != null) {
      searchSql = "delete from type where id =${map["id"]}";
    }
    await db.query(searchSql);
    resultBean.msg = "删除成功";
    resultBean.code = 0;
    return resultBean.toJson();
  }
}
