import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Handler> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen(
      (message) {
        channel.sink.add('echo => $message!');
      },
      onDone: () => print('disconnected'),
    );
  });

  return handler;
}
