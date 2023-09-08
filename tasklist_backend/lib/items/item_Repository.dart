import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';

part 'item_Repository.g.dart';

@visibleForTesting

/// Data source - in-memory cache
Map<String, TaskItem> itemtDb = {};

@JsonSerializable()

/// TaskList class
class TaskItem extends Equatable {
  /// Constructor
  const TaskItem({
    required this.id,
    required this.listid,
    required this.name,
    required this.description,
    required this.status,
  });

  /// deserialization
  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  /// copyWith method
  TaskItem copyWith(
      {String? id,
      String? listid,
      String? name,
      String? description,
      bool? status}) {
    return TaskItem(
      id: id ?? this.id,
      listid: listid ?? this.listid,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  /// Item's id
  final String id;

  /// List id of where the item belongs
  final String listid;

  /// Item's name
  final String name;

  /// Item's description
  final String description;

  /// Item's status
  final bool status;

  /// Serialization
  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  @override
  List<Object?> get props => [id, name];
}

/// Repository class for TaskItem
///
class TaskItemRepository {
  /// Check in the internal data source for an item with the given [id
  Future<TaskItem?> itemById(String id) async {
    return itemtDb[id];
  }

  /// Get all the items from the data source
  Map<String, dynamic> getAllItems() {
    final formattedItems = <String, dynamic>{};

    if (itemtDb.isNotEmpty) {
      itemtDb.forEach((key, value) {
        formattedItems[key] = value.toJson();
      });
    }

    return formattedItems;
  }

  /// Get items by list id
  Map<String, dynamic> getItemsByList(String listid) {
    final formattedItems = <String, dynamic>{};
    if (itemtDb.isNotEmpty) {
      itemtDb.forEach((key, value) {
        if (value.listid == listid) {
          formattedItems[key] = value.toJson();
        }
      });
    }
    return formattedItems;
  }

  /// Create a new item with a given information
  String createItem({
    required String name,
    required String listid,
    required String description,
    required bool status,
  }) {
    /// dynamically generates the id
    final id = name.hashValue;

    /// create our new TaskiTEM object and pass ALL THE parameters
    final item = TaskItem(
        id: id,
        name: name,
        listid: listid,
        description: description,
        status: status);

    /// add a new Tasklist object to our data source
    itemtDb[id] = item;

    return id;
  }

  /// Deletes the Taskitem object with the given [id]
  void deleteItem(String id) {
    itemtDb.remove(id);
  }

  /// Update operation
  Future<void> updateItem({
    required String id,
    required String name,
    required String listid,
    required String description,
    required bool status,
  }) async {
    final currentitem = itemtDb[id];

    if (currentitem == null) {
      return Future.error(Exception('Item not found'));
    }

    itemtDb[id] = TaskItem(
        id: id,
        name: name,
        listid: listid,
        description: description,
        status: status);
  }
}
