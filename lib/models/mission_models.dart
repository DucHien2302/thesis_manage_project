import 'package:json_annotation/json_annotation.dart';

part 'mission_models.g.dart';

@JsonSerializable()
class Mission {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'start_date')
  final DateTime? startDate;

  @JsonKey(name: 'end_date')
  final DateTime? endDate;

  @JsonKey(name: 'thesis_id')
  final String thesisId;

  @JsonKey(name: 'create_datetime')
  final DateTime? createdAt;

  @JsonKey(name: 'update_datetime')
  final DateTime? updatedAt;

  @JsonKey(name: 'tasks')
  final List<Task>? tasks;

  // Calculated field for progress
  double get progress {
    if (tasks == null || tasks!.isEmpty) return 0.0;
    
    int completedTasks = tasks!.where((task) => task.isCompleted).length;
    return completedTasks / tasks!.length;
  }

  Mission({
    required this.id,
    required this.name,
    required this.description,
    this.startDate,
    this.endDate,
    required this.thesisId,
    this.createdAt,
    this.updatedAt,
    this.tasks,
  });

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);
  Map<String, dynamic> toJson() => _$MissionToJson(this);
}

@JsonSerializable()
class Task {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'due_date')
  final DateTime? dueDate;

  @JsonKey(name: 'mission_id')
  final String missionId;

  @JsonKey(name: 'status')
  final int status;

  @JsonKey(name: 'priority')
  final int priority;

  @JsonKey(name: 'priority_text')
  final String? priorityText;
  @JsonKey(name: 'comments')
  final List<dynamic>? comments;
  
  // Computed property to check if task is completed
  bool get isCompleted => status == 2; // Assuming status 2 means completed
  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.missionId,
    required this.status,
    required this.priority,
    this.priorityText,
    this.comments,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? missionId,
    int? status,
    int? priority,
    String? priorityText,
    List<dynamic>? comments,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      missionId: missionId ?? this.missionId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      priorityText: priorityText ?? this.priorityText,
      comments: comments ?? this.comments,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
