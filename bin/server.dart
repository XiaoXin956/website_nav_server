import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'bean/result_bean.dart';
import 'repository/knowledge_repository.dart';
import 'repository/type_repository.dart';
import 'repository/user_repository.dart';
import 'user_middleware.dart';

TypeRepository typeRepository = TypeRepository();
UserRepository userRepository = UserRepository();
IKnowledgeRepository knowledgeRepository = KnowledgeRepository();

final _router = Router()
  ..post('/add_type', _webSiteAddType)
  ..post('/search_type', _webSiteSearchType)
  ..post('/update_type', _webSiteUpdateType)
  ..post('/del_type', _webSiteDelType)
  ..post('/user_reg', _userReg)
  ..post('/user_update', _userUpdate)
  ..post('/user_login', _userSearch)
  ..post('/knowledge', _knowledge);

Future<Response> _webSiteAddType(Request request) async {
  var body = await request.readAsString();
  dynamic reqMap = json.decode(body);
  dynamic result = await typeRepository.addTypeChild(reqMap);
  return Response.ok(json.encode(result));
}

Future<Response> _webSiteSearchType(Request request) async {
  var body = await request.readAsString();
  dynamic result;
  dynamic reqMap = json.decode(body);
  if (reqMap["type"] == "child") {
    result = await typeRepository.searchTypeChild(reqMap);
  } else if (reqMap["type"] == "all") {
    result = await typeRepository.searchTypeAll(reqMap);
  }
  return Response.ok(json.encode(result));
}

Future<Response> _webSiteUpdateType(Request request) async {
  var body = await request.readAsString();
  dynamic result;
    result = await typeRepository.updateTypeChild(json.decode(body));
  return Response.ok(json.encode(result));
}

Future<Response> _webSiteDelType(Request request) async {
  var body = await request.readAsString();
  dynamic result;
    result = await typeRepository.delTypeChild(json.decode(body));
  return Response.ok(json.encode(result));
}

Future<Response> _userReg(Request request) async {
  var body = await request.readAsString();
  dynamic result;
  result = await userRepository.userReg(json.decode(body));
  return Response.ok(json.encode(result));
}
Future<Response> _userSearch(Request request) async {
  var body = await request.readAsString();
  dynamic result;
  result = await userRepository.userSearch(json.decode(body));
  return Response.ok(json.encode(result));
}
Future<Response> _userUpdate(Request request) async {
  var body = await request.readAsString();
  dynamic result;
  result = await userRepository.userUpdate(json.decode(body));
  return Response.ok(json.encode(result));
}

Future<Response> _knowledge(Request request) async {
  var body = await request.readAsString();
   var reqMap = json.decode(body);
  dynamic result;

  if(reqMap["type"]=="search"){
    // 查询
    result = await knowledgeRepository.searchKnowledge(reqMap);
  }else if(reqMap["type"]=="add"){
    // 添加
    result = await knowledgeRepository.addKnowledge(reqMap);
  }else if(reqMap["type"]=="update"){
    // 修改
    result = await knowledgeRepository.updateKnowledge(reqMap);
  } else if(reqMap["type"]=="remove"){
    // 删除
    result = await knowledgeRepository.removeKnowledge(reqMap);
  }
  return Response.ok(json.encode(result));
}


void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}