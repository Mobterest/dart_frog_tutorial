// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_Repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => TaskItem(
      id: json['id'] as String,
      listid: json['listid'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as bool,
    );

Map<String, dynamic> _$TaskItemToJson(TaskItem instance) => <String, dynamic>{
      'id': instance.id,
      'listid': instance.listid,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
    };
