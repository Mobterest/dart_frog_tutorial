import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tasklist_backend/repository/user/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _createUser(context),
    HttpMethod.get => _getUser(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getUser(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String;
  final password = body['password'] as String;

  final user = await context
      .read<UserRepository>()
      .userFromCredentials(username, password);

  if (user == null) {
    return Response(statusCode: HttpStatus.forbidden);
  } else {
    return Response.json(
      body: {
        'id': user.id,
        'name': user.name,
        'username': user.username,
      },
    );
  }
}

Future<Response> _createUser(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;
  final username = body['username'] as String?;
  final password = body['password'] as String?;

  final userRepository = context.read<UserRepository>();

  if (name != null && username != null && password != null) {
    final id = await userRepository.createUser(
        name: name, username: username, password: password);
    return Response.json(body: {'id': id});
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
