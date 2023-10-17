import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'repository/type_repository.dart';

TypeRepository typeRepository = TypeRepository();

final _router = Router()
  ..post('/add_type', _webSiteAddType)
  ..post('/search_type', _webSiteSearchType)
  ..post('/update_type', _webSiteUpdateType)
  ..post('/del_type', _webSiteDelType);

Future<Response> _webSiteAddType(Request request) async {
  var body = await request.readAsString();
  dynamic result;
  dynamic reqMap = json.decode(body);
  if (reqMap["type"] == "parent") {
    result = await typeRepository.addTypeParent(reqMap);
  } else if (reqMap["type"] == "child") {
    result = await typeRepository.addTypeChild(reqMap);
  }
  return Response.ok("$result");
}

Future<Response> _webSiteSearchType(Request request) async {
  var body = await request.readAsString();
  dynamic result;
  dynamic reqMap = json.decode(body);
  if (reqMap["type"] == "parent") {
    result = await typeRepository.searchTypeParent(reqMap);
  } else if (reqMap["type"] == "child") {
    result = await typeRepository.searchTypeChild(reqMap);
  }else  if (reqMap["type"] == "all") {
    result = await typeRepository.searchTypeAll(reqMap);
  }
  return Response.ok(json.encode(result));
}

Future<Response> _webSiteUpdateType(Request request) async {
  var body = await request.readAsString();
  dynamic result;
  dynamic reqMap = json.decode(body);
  if (reqMap["type"] == "parent") {
    result = await typeRepository.updateTypeParent(json.decode(body));
  } else if (reqMap["type"] == "child") {
    result = await typeRepository.updateTypeChild(json.decode(body));
  }
  return Response.ok(json.encode(result));
}

Future<Response> _webSiteDelType(Request request) async {
  var body = await request.readAsString();
  dynamic result;
  dynamic reqMap = json.decode(body);
  if (reqMap["type"] == "parent") {
    result = await typeRepository.delTypeParent(json.decode(body));
  } else if (reqMap["type"] == "child") {
    result = await typeRepository.delTypeChild(json.decode(body));
  }
  return Response.ok(json.encode(result));
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
