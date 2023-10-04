import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getRecipes(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getRecipes(RequestContext context) async {
  final response = await http.get(
    Uri.parse('https://low-carb-recipes.p.rapidapi.com/random'),
    headers: {
      'X-RapidAPI-Key': 'b8849a6c88msha9a7ef62f3ef62ap1d9327jsn03d96a53bc74',
      'X-RapidAPI-Host': 'low-carb-recipes.p.rapidapi.com'
    },
  );

  if (response.statusCode == 200) {
    return Response.json(body: response.body);
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
