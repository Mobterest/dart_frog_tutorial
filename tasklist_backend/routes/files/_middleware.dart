import 'package:dart_frog/dart_frog.dart';
import 'package:tasklist_backend/config.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Configuration>((_) => Configuration()));
}
