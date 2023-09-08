import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tasklist_backend/lists/list_Repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getLists(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getLists(RequestContext context) async {
  final lists = context.read<TaskListRepository>().getAllLists();
  return Response.json(body: lists);
}
