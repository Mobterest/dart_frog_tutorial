import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    print('connected');

    channel.stream.listen(
      (message) {
        print(message);

        channel.sink.add('echo => $message!');
      },
      onDone: () => print('disconnected'),
    );
  });

  return handler(context);
}
