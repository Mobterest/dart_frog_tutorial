import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:redis/redis.dart';

//1 - logged in , 0 - logged out

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getLoginStatus(context),
    HttpMethod.post => _setLoginStatus(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getLoginStatus(RequestContext context) async {
  final value = await context
      .read<Command>()
      .send_object(['GET', 'loggedin']).then((value) => value);

  if (value == null) {
    const status = 0;
    await context.read<Command>().send_object(['SET', 'loggedin', status]);
    return Response(statusCode: HttpStatus.noContent);
  } else {
    return Response.json(
      body: {'success': true, 'message': int.parse(value.toString())},
    );
  }
}

Future<Response> _setLoginStatus(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final status = body['loggedin'] as int?;
  var success = false;

  try {
    await context.read<Command>().send_object(['SET', 'loggedin', status]);
    success = true;
  } catch (e) {
    success = false;
  }

  return Response.json(body: {'success': success});
}
