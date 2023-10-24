// import 'package:shelf/shelf.dart';
//
// Middleware userMiddleware({void Function(String message, bool isError)? data}) => (innerHandler) {
//       final theData = data;
//       return (request) {
//         var startTime = DateTime.now();
//         var watch = Stopwatch()..start();
//         return Future.sync(() => innerHandler(request)).then((response) {
//           return response;
//         }, onError: (error, stackTrace) {});
//       };
//
//     };
//
// Middleware logRequests2({void Function(String message, bool isError)? logger}) => (innerHandler) {
//       final theLogger = logger ?? _defaultLogger;
//
//       return (request) {
//         var startTime = DateTime.now();
//         var watch = Stopwatch()..start();
//
//         return Future.sync(() => innerHandler(request)).then((response) {
//           var msg = _message(startTime, response.statusCode, request.requestedUri, request.method, watch.elapsed);
//
//           theLogger(msg, false);
//
//           return response;
//         }, onError: (Object error, StackTrace stackTrace) {
//           if (error is HijackException) throw error;
//
//           var msg = _errorMessage(startTime, request.requestedUri, request.method, watch.elapsed, error, stackTrace);
//
//           theLogger(msg, true);
//
//           // ignore: only_throw_errors
//           throw error;
//         });
//       };
//     };
