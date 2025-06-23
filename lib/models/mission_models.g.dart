// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mission _$MissionFromJson(Map<String, dynamic> json) => Mission(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  startDate:
      json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
  endDate:
      json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
  thesisId: json['thesis_id'] as String,
  createdAt:
      json['create_datetime'] == null
          ? null
          : DateTime.parse(json['create_datetime'] as String),
  updatedAt:
      json['update_datetime'] == null
          ? null
          : DateTime.parse(json['update_datetime'] as String),
  tasks:
      (json['tasks'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$MissionToJson(Mission instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'thesis_id': instance.thesisId,
  'create_datetime': instance.createdAt?.toIso8601String(),
  'update_datetime': instance.updatedAt?.toIso8601String(),
  'tasks': instance.tasks,
};

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  dueDate:
      json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
  missionId: json['mission_id'] as String,
  status: (json['status'] as num).toInt(),
  priority: (json['priority'] as num).toInt(),
  priorityText: json['priority_text'] as String?,
  comments: json['comments'] as List<dynamic>?,
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'due_date': instance.dueDate?.toIso8601String(),
  'mission_id': instance.missionId,
  'status': instance.status,
  'priority': instance.priority,
  'priority_text': instance.priorityText,
  'comments': instance.comments,
};
