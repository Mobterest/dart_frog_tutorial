import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.patch => _updateList(context, id),
    HttpMethod.delete => _deleteList(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _updateList(RequestContext context, String id) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;

  try {
    await context
        .read<Db>()
        .collection('lists')
        .updateOne(where.eq('id', id), modify.set('name', name));

    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response(statusCode: HttpStatus.badRequest);
  }
}

Future<Response> _deleteList(RequestContext context, String id) async {
  await context.read<Db>().collection('lists').deleteOne({'id': id}).then(
    (value) {
      return Response(statusCode: HttpStatus.noContent);
    },
    onError: (e) {
      return Response(statusCode: HttpStatus.badRequest);
    },
  );

  return Response(statusCode: HttpStatus.badRequest);
}
