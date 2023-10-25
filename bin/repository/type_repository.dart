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

  Future<dynamic> addTypeParent(dynamic map);

  Future<dynamic> searchTypeParent(dynamic map);

  Future<dynamic> updateTypeParent(dynamic map);

  Future<dynamic> delTypeParent(dynamic map);
}

class TypeRepository extends ITypeRepository {
  // 添加
  Future<dynamic> addTypeChild(dynamic map) async {
    ResultBean resultBean = ResultBean();
    if (map["parent_id"]==null) {
      resultBean.msg = "父级id不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
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

    var query = db.query("insert into type_child (name,parent_id) values(?,?)", [
      map['name'],
      map['parent_id'],
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
        searchSql = "select id,name,parent_id from type_child where id =${map["id"]}";
    } else {
        searchSql = "select id,name,parent_id from type_child where name like '%${map["name"] ?? ''}%'";
    }
    var queryType = await db.query(searchSql);
    List<TypeBean> typeBeans = [];
    for (var row in queryType) {
      print('id: ${row[0]}, name: ${row[1]} ');
      TypeBean typeBean = TypeBean(id: row['id'], name: row['name'], parentId: row['parent_id']);
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
    await db.query('update type_child set name=?,parent_id=? where id=?', [map['name'], map['parent_id'], map['id']]);
    var queryType = await db.query("select * from type_child where id =${map['id']}");
    TypeBean? typeBean;
    for (var row in queryType) {
      print('id: ${row[0]}, name: ${row[1]} ');
      typeBean = TypeBean(id: row[0], name: row[1], parentId: row[2]);
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
    String searchSql = "";
    if (map["id"] != null) {
      searchSql = "delete from type_child where id =${map["id"]}";
    }
    await db.query(searchSql);
    resultBean.msg = "删除成功";
    resultBean.code = 0;
    return resultBean.toJson();
  }

  ///////////////// 父级

  // 添加父级
  Future<dynamic> addTypeParent(dynamic map) async {
    ResultBean resultBean = ResultBean();
    if (map["name"]==null||map["name"]=="") {
      resultBean.msg = "类型名称不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    var queryCount = await db.query("select * from type_parent where name ='${map['name']}'");
    for (var value in queryCount) {
      resultBean.msg = "该数据存在";
      resultBean.code = -1;
      return resultBean.toJson();
    }

    var query = db.query("insert into type_parent (name) values(?)", [map['name']]);
    print(query);
    resultBean.msg = "添加成功";
    resultBean.code = 0;
    return resultBean.toJson();
  }

  // 查询
  Future<dynamic> searchTypeParent(dynamic map) async {
    ResultBean resultBean = ResultBean();
    MySqlConnection db = await DbUtils.instance();
    String searchSql = "";
    if (map["id"] != null) {
        searchSql = "select id,name from type_parent where id =${map["id"]}";

    } else {
        searchSql = "select id,name from type_parent where name like '%${map["name"] ?? ''}%'";

    }
    var queryType = await db.query(searchSql);
    List<TypeBean> typeBeans = [];
    for (var row in queryType) {
      print('id: ${row[0]}, name: ${row[1]} ');
      TypeBean typeBean = TypeBean(id: row[0], name: row[1], parentId: null);
      typeBeans.add(typeBean);
    }
    resultBean.msg = "查询成功";
    resultBean.code = 0;
    resultBean.data = json.encode(typeBeans);
    return resultBean.toJson();
  }

  // 更新
  Future<dynamic> updateTypeParent(dynamic map) async {
    ResultBean resultBean = ResultBean();
    if (map['id'].toString().isEmpty || map['name'].toString().isEmpty) {
      resultBean.msg = "参数不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    // 先查询是否存在
    var queryTypeCount = await db.query("select * from type_parent where id =${map['id']}");
    if (queryTypeCount.fields.isEmpty) {
      resultBean.msg = "暂无此数据";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    await db.query('update type_parent set name=? where id=?', [map['name'], map['id']]);
    var queryType = await db.query("select * from type_parent where id =${map['id']}");
    TypeBean? typeBean;
    for (var row in queryType) {
      print('id: ${row[0]}, name: ${row[1]} ');
      typeBean = TypeBean(id: row[0], name: row[1], parentId: null);
    }
    resultBean.msg = "修改成功";
    resultBean.code = 0;
    resultBean.data = typeBean!.toJson();
    return resultBean.toJson();
  }

  // 修改
  Future<dynamic> delTypeParent(dynamic map) async {
    ResultBean resultBean = ResultBean();
    if (map['id'].toString().isEmpty) {
      resultBean.msg = "参数不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    String delSql = "";
    String delChildSql = "";
    // 关联的子标签也会被删除
    if (map["id"] != null) {
      delSql = "delete from type_parent where id =${map["id"]}";
      delChildSql = "delete from type_child where parent_id =${map["id"]}";
    }
    await db.query(delSql);
    await db.query(delChildSql);
    resultBean.msg = "删除成功";
    resultBean.code = 0;
    return resultBean.toJson();
  }

  @override
  Future searchTypeAll(map) async {
    ResultBean resultBean = ResultBean();
    MySqlConnection db = await DbUtils.instance();
    String searchSql = "";
      searchSql = "select id,name from type_parent";

    var queryType = await db.query(searchSql);
    List<TypeBean> typeParentBeans = [];
    for (var rowParent in queryType) {
      print('id: ${rowParent[0]}, name: ${rowParent[1]} ');
      TypeBean typeBeanParent = TypeBean(id: rowParent[0], name: rowParent[1], parentId: null); // 查询的父类
      typeParentBeans.add(typeBeanParent);
    }
    List<TypeBean> typeChildAllBeans = [];
    String childSearchSql = "";
      childSearchSql = "select id,name,parent_id from type_child";

    var queryChildType = await db.query(childSearchSql);
    for (var row in queryChildType) {
      print('id: ${row[0]}, name: ${row[1]} ');
      TypeBean typeBean = TypeBean(id: row[0], name: row[1], parentId: row[2]);
      typeChildAllBeans.add(typeBean);
    }
    // 整理
    for (var valueParent in typeParentBeans) {
      int parentId = valueParent.id!;
      var childData = typeChildAllBeans.where((e) {
        if (e.parentId == parentId) {
          return true;
        }else{
          return false;
        }
      }).toList();
      valueParent.childBean = childData;
      print("子菜单是:${childData}");
    }

    resultBean.msg = "查询成功";
    resultBean.code = 0;
    resultBean.data = json.encode(typeParentBeans.map((e) => e.toJson()).toList());
    return resultBean.toJson();
  }
}
