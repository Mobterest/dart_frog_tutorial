import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:tasklist_backend/config.dart';

Future<Response> onRequest(RequestContext context) async {
  final config = await context.read<Configuration>().getFileConfigurations();

  return switch (context.request.method) {
    HttpMethod.get => _downloadFiles(context, config),
    HttpMethod.post => _uploadFiles(context, config),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _uploadFiles(
    RequestContext context, Map<String, dynamic> config) async {
  final formData = await context.request.formData();
  final file = formData.files['file'];

  print(file);

  if (file == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final publicPath = config['public_path'] as String;
  try {
    File(publicPath + file.name).writeAsBytesSync(await file.readAsBytes());
  } catch (e, s) {
    print('Failed to write into $file: $e\nStacktrace: $s');
  }

  return Response.json(
    body: {'message': 'Successfully uploaded ${file.name}'},
  );
}

Future<Response> _downloadFiles(
  RequestContext context,
  Map<String, dynamic> config,
) async {
  final dir = Directory(config['public_path'] as String);
  final entities = await dir.list().toList();
  final files = <String>[];
  try {
    for (final name in entities) {
      files.add(name.uri.pathSegments.last);
    }
  } catch (e) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  return Response.json(body: files);
}
