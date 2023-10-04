import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:tasklist_backend/repository/session/session_repository.dart';
import 'package:tasklist_backend/repository/user/user_repository.dart';

final userRepository = UserRepository();
final sessionRepository = SessionRepository();

Handler middleware(Handler handler) {
  return handler
      .use(
        bearerAuthentication<User>(
          authenticator: (context, token) async {
            final sessionRepo = context.read<SessionRepository>();
            final userRepo = context.read<UserRepository>();
            final session = sessionRepo.sessionFromToken(token);
            return session != null ? userRepo.userFromId(session.userId) : null;
          },
          applies: (RequestContext context) async =>
              context.request.method != HttpMethod.post &&
              context.request.method != HttpMethod.get,
        ),
      )
      .use(provider<UserRepository>((_) => userRepository))
      .use(provider<SessionRepository>((_) => sessionRepository));
}
