// 导航类型
import 'dart:convert';

import 'package:mysql1/mysql1.dart';

import '../bean/result_bean.dart';
import '../bean/type_bean.dart';
import '../db_utils.dart';

abstract class ITypeRepository {
  Future<dynamic> searchTypeAll(dynamic map);

  Future<dynamic> addTypeChild(dynamic map);

  Future<dynamic> searchTypeChild(dynamic map);

  Future<dynamic> updateTypeChild(dynamic map);

  Future<dynamic> delTypeChild(dynamic map);

}

class TypeRepository extends ITypeRepository {
  // 添加
  Future<dynamic> addTypeChild(dynamic map) async {
    ResultBean resultBean = ResultBean();
    if (map["name"].isEmpty) {
      resultBean.msg = "类型不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();

    var queryCount = await db.query("select * from type_child where name ='${map['name']}'");
    for (var value in queryCount) {
      resultBean.msg = "该数据存在";
      resultBean.code = -1;
      return resultBean.toJson();
    }

    var query = db.query("insert into type_child (name) values(?)", [
      map['name']
    ]);
    print(query);
    resultBean.msg = "添加成功";
    resultBean.code = 0;
    return resultBean.toJson();
  }

  // 查询
  Future<dynamic> searchTypeChild(dynamic map) async {
    ResultBean resultBean = ResultBean();
    MySqlConnection db = await DbUtils.instance();
    String searchSql = "";
    if (map["id"] != null) {
        searchSql = "select id,name from type_child where id =${map["id"]}";
    } else {
        searchSql = "select id,name from type_child where name like '%${map["name"] ?? ''}%'";
    }
    var queryType = await db.query(searchSql);
    List<TypeBean> typeBeans = [];
    for (var row in queryType) {
      print('id: ${row[0]}, name: ${row[1]} ');
      TypeBean typeBean = TypeBean(id: row['id'], name: row['name']);
      typeBeans.add(typeBean);
    }
    resultBean.msg = "查询成功";
    resultBean.code = 0;
    resultBean.data = json.encode(typeBeans);
    return resultBean.toJson();
  }

  // 更新
  Future<dynamic> updateTypeChild(dynamic map) async {
    ResultBean resultBean = ResultBean();
    if (map['id'].toString().isEmpty || map['name'].toString().isEmpty) {
      resultBean.msg = "参数不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    // 先查询是否存在
    var queryTypeCount = await db.query("select * from type_child where id =${map['id']}");
    if (queryTypeCount.fields.isEmpty) {
      resultBean.msg = "暂无此数据";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    await db.query('update type_child set name=? where id=?', [map['name'], map['id']]);
    var queryType = await db.query("select * from type_child where id =${map['id']}");
    TypeBean? typeBean;
    for (var row in queryType) {
      typeBean = TypeBean(id: row[0], name: row[1]);
    }
    resultBean.msg = "修改成功";
    resultBean.code = 0;
    resultBean.data = typeBean?.toJson();
    return resultBean.toJson();
  }

  // 删除
  Future<dynamic> delTypeChild(dynamic map) async {
    ResultBean resultBean = ResultBean();
    if (map['id'].toString().isEmpty) {
      resultBean.msg = "参数不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    String searchSql = "delete from type_child where id =${map["id"]}";
    await db.query(searchSql);
    resultBean.msg = "删除成功";
    resultBean.code = 0;
    return resultBean.toJson();
  }

  @override
  Future searchTypeAll(map) async {
    ResultBean resultBean = ResultBean();
    MySqlConnection db = await DbUtils.instance();

    List<TypeBean> typeChildAllBeans = [];
    String childSearchSql = "select id,name from type_child";

    var queryChildType = await db.query(childSearchSql);
    for (var row in queryChildType) {
      TypeBean typeBean = TypeBean(id: row[0], name: row[1]);
      typeChildAllBeans.add(typeBean);
    }

    resultBean.msg = "查询成功";
    resultBean.code = 0;
    resultBean.data = json.encode(typeChildAllBeans);
    return resultBean.toJson();
  }
}
