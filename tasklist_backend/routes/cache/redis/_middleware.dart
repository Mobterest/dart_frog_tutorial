import 'package:dart_frog/dart_frog.dart';
import 'package:redis/redis.dart';

final conn = RedisConnection();

Handler middleware(Handler handler) {
  return (context) async {
    Response response;

    try {
      final command = await conn.connect('localhost', 8091);

      try {
        await command.send_object(
          ['AUTH', 'default', 'X3tfQSHnltsa-yx8badihKv1tU2in9OV'],
        );

        response =
            await handler.use(provider<Command>((_) => command)).call(context);
      } catch (e) {
        response =
            Response.json(body: {'success': false, 'message': e.toString()});
      }
    } catch (e) {
      response =
          Response.json(body: {'success': false, 'message': e.toString()});
    }

    return response;
  };
}
