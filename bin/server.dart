import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'repository/type_repository.dart';

TypeRepository typeRepository = TypeRepository();

final _router = Router()
  ..get('/', _rootHandler)
  ..post('/add_type', _addWebSiteAddType)
  ..post('/search_type', _addWebSiteSearchType)
  ..post('/update_type', _addWebSiteUpdateType)
  ..post('/del_type', _addWebSiteDelType);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Future<Response> _addWebSiteAddType(Request request) async {
  var body = await request.readAsString();
  dynamic result = await typeRepository.addType(json.decode(body)["name"]);
  return Response.ok("$result");
}

Future<Response> _addWebSiteSearchType(Request request) async {
  var body = await request.readAsString();
  dynamic result = await typeRepository.searchType(json.decode(body));
  return Response.ok(json.encode(result));
}

Future<Response> _addWebSiteUpdateType(Request request) async {
  var body = await request.readAsString();
  dynamic result = await typeRepository.updateType(json.decode(body));
  return Response.ok("$result");
}
Future<Response> _addWebSiteDelType(Request request) async {
  var body = await request.readAsString();
  dynamic result = await typeRepository.delType(json.decode(body));
  return Response.ok("$result");
}


void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '80');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
