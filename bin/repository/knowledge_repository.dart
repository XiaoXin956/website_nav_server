import 'dart:convert';

import 'package:mysql1/mysql1.dart';

import '../bean/knowledge_bean.dart';
import '../bean/result_bean.dart';
import '../bean/type_bean.dart';
import '../db_utils.dart';

abstract class IKnowledgeRepository {
  // 添加
  Future<dynamic> addKnowledge(dynamic map);

  // 删除
  Future<dynamic> removeKnowledge(dynamic map);

  // 修改
  Future<dynamic> updateKnowledge(dynamic map);

  // 查询
  Future<dynamic> searchKnowledge(dynamic map);
}

class KnowledgeRepository extends IKnowledgeRepository {
  @override
  Future<dynamic> addKnowledge(map) async {
    ResultBean resultBean = ResultBean();
    if (map["type_id"] == null) {
      resultBean.msg = "类型不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    if (map["text"] == null || map["text"] == '') {
      resultBean.msg = "名称不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    if (map["url"] == null || map["url"] == '') {
      resultBean.msg = "链接不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    var queryCount = await db.query("select * from knowledge where text ='${map['text']}' and url='${map['url']}'");
    for (var value in queryCount) {
      resultBean.msg = "该数据存在";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    await db.query("insert into knowledge (label,text,url,type_id) values(?,?,?,?)", [
      map['label'],
      map['text'],
      map['url'],
      map['type_id'],
    ]);
    resultBean.msg = "添加成功";
    resultBean.code = 0;
    return resultBean.toJson();
  }

  @override
  Future<dynamic> removeKnowledge(map) async {
    ResultBean resultBean = ResultBean();
    if (map['id'].toString().isEmpty) {
      resultBean.msg = "参数不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    String searchSql = "";
    if (map["id"] != null) {
      searchSql = "delete from knowledge where id =${map["id"]}";
    }
    await db.query(searchSql);
    resultBean.msg = "删除成功";
    resultBean.code = 0;
    return resultBean.toJson();
  }

  @override
  Future<dynamic> searchKnowledge(map) async {
    ResultBean resultBean = ResultBean();
    MySqlConnection db = await DbUtils.instance();
    String searchSql = "";
    if (map["id"] != null) {
      searchSql = "select * from knowledge where id =${map["id"]}";
    } else {
      searchSql = "select * from knowledge where text like '%${map["text"] ?? ''}%'";
    }
    var queryType = await db.query(searchSql);
    List<KnowledgeBean> knowledgeAllData = []; // 所有的资源
    for (var row in queryType) {
      KnowledgeBean knowledgeBean = KnowledgeBean(id: row['id'], label: row['label'], text: row['text'], url: row['url'], typeId: row['type_id'], describe: row['describe']);
      knowledgeAllData.add(knowledgeBean);
    }

    // 查询所有的类型
    List<TypeBean> typeChildAllBeans = [];
    String childSearchSql = "";
    childSearchSql = "select id,name,parent_id from type_child";

    var queryChildType = await db.query(childSearchSql);
    for (var row in queryChildType) {
      TypeBean typeBean = TypeBean(id: row['id'], name: row['name'], parentId: row['parent_id']);
      typeChildAllBeans.add(typeBean);
    }

    // 整合
    List<dynamic> data = [];
    typeChildAllBeans.forEach((element) {
      // 判断返回集合
      List<KnowledgeBean> result = knowledgeAllData.where((knowValue) => knowValue.typeId == element.id).toList();
      // 添加到
      data.add({"type_bean": element, "result": result});
    });

    print(data);
    print(json.encode(data));

    resultBean.msg = "查询成功";
    resultBean.code = 0;
    resultBean.data = json.encode(data);
    return resultBean.toJson();
  }

  @override
  Future<dynamic> updateKnowledge(map) async {
    ResultBean resultBean = ResultBean();
    if (map['id'].toString().isEmpty) {
      resultBean.msg = "参数不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    if (map['text'].toString().isEmpty) {
      resultBean.msg = "文本不允许为空";
      resultBean.code = -1;
      return resultBean.toJson();
    }
    MySqlConnection db = await DbUtils.instance();
    var queryCount = await db.query("select * from knowledge where id =${map['id']}");
    if (queryCount.fields.isEmpty) {
      resultBean.msg = "暂无此数据";
      resultBean.code = -1;
      return resultBean.toJson();
    }

    StringBuffer updateSql = StringBuffer("update knowledge set ");
    if (map['text'] != null) {
      updateSql.write("text='${map['text']}', ");
    }
    if (map['label'] != null) {
      updateSql.write("label='${map['label']}', ");
    }
    if (map['url'] != null) {
      updateSql.write("url='${map['url']}', ");
    }
    if (map['type_id'] != null) {
      updateSql.write("type_id=${map['type_id']} ");
    }
    updateSql.write("where id=${map['id']} ");

    await db.query(updateSql.toString());
    var queryType = await db.query("select * from knowledge where id =${map['id']}");
    KnowledgeBean? knowledgeBean;
    for (var row in queryType) {
      knowledgeBean = KnowledgeBean(id: row['id'], label: row['label'], text: row['text'], url: row['url'], typeId: row['type_id'], describe: row['describe']);
    }
    resultBean.msg = "修改成功";
    resultBean.code = 0;
    resultBean.data = knowledgeBean!.toJson();
    return resultBean.toJson();
  }
}
