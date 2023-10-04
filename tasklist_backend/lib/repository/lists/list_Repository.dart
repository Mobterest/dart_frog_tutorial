import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';

part 'list_Repository.g.dart';

@visibleForTesting

/// Data source - in-memory cache
Map<String, TaskList> listDb = {};

@JsonSerializable()

/// TaskList class
class TaskList extends Equatable {
  /// Constructor
  const TaskList({required this.id, required this.name});

  /// deserialization
  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);

  /// copyWith method
  TaskList copyWith({
    String? id,
    String? name,
  }) {
    return TaskList(id: id ?? this.id, name: name ?? this.name);
  }

  /// List's id
  final String id;

  /// List's name
  final String name;

  /// Serialization
  Map<String, dynamic> toJson() => _$TaskListToJson(this);

  @override
  List<Object?> get props => [id, name];
}

/// Repository class for TaskList
///
class TaskListRepository {
  /// Check in the internal data source for a list with the given [id
  Future<TaskList?> listById(String id) async {
    return listDb[id];
  }

  /// Get all the lists from the data source
  Map<String, dynamic> getAllLists() {
    final formattedLists = <String, dynamic>{};

    if (listDb.isNotEmpty) {
      listDb.forEach((key, value) {
        formattedLists[key] = value.toJson();
      });
    }

    return formattedLists;
  }

  /// Create a new list with a given [name]
  String createList({required String name}) {
    /// dynamically generates the id
    final id = name.hashValue;

    /// create our new TaskList object and pass our two parameters
    final list = TaskList(id: id, name: name);

    /// add a new Tasklist object to our data source
    listDb[id] = list;

    return id;
  }

  /// Deletes the Tasklist object with the given [id]
  void deleteList(String id) {
    listDb.remove(id);
  }

  /// Update operation
  Future<void> updateList({required String id, required String name}) async {
    final currentlist = listDb[id];

    if (currentlist == null) {
      return Future.error(Exception('List not found'));
    }

    listDb[id] = TaskList(id: id, name: name);
  }
}
