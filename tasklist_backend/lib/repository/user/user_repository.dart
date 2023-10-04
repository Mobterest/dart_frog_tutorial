import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';

@visibleForTesting

/// IN MEMORY CACHE
Map<String, User> userDb = {};

/// User's class
class User extends Equatable {
  /// Constructor
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  /// User's id
  final String id;

  /// User's name
  final String name;

  /// User's username
  final String username;

  /// User's password
  final String password;

  @override
  List<Object?> get props => [id, name, username, password];
}

/// User's Repository
class UserRepository {
  /// Checks in the database for a user with the provided username and password
  Future<User?> userFromCredentials(String username, String password) async {
    final hashedPassword = password.hashValue;

    final users = userDb.values.where(
      (user) => user.username == username && user.password == hashedPassword,
    );

    if (users.isNotEmpty) {
      return users.first;
    }

    return null;
  }

  /// search for a user by id
  Future<User?> userFromId(String id) async {
    return userDb[id];
  }

  /// Creates a new user
  Future<String> createUser(
      {required String name,
      required String username,
      required String password}) {
    final id = username.hashValue;

    final user = User(
      id: id,
      username: username,
      password: password.hashValue,
      name: name,
    );

    userDb[id] = user;

    return Future.value(id);
  }

  /// Delete a user
  void deleteUser(String id) {
    userDb.remove(id);
  }

  /// Update user
  Future<void> updateUser({
    required String id,
    required String? name,
    required String? username,
    required String? password,
  }) async {
    final currentUser = userDb[id];

    if (currentUser == null) {
      return Future.error(Exception('User not found'));
    }

    if (password != null) {
      password = password.hashValue;
    }

    final user = User(
      id: id,
      name: name ?? currentUser.name,
      username: username ?? currentUser.username,
      password: password ?? currentUser.password,
    );

    userDb[id] = user;
  }
}
