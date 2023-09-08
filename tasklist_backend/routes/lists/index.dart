import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tasklist_backend/lists/list_Repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _createList(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _createList(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  final name = body['name'] as String;

  final listRepository = context.read<TaskListRepository>();

  if (name != null) {
    final id = listRepository.createList(name: name);

    return Response.json(body: {'id': id});
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
