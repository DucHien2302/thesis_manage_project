import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'batch_models.g.dart';

@JsonSerializable()
class BatchModel extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;

  const BatchModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) => 
      _$BatchModelFromJson(json);
  Map<String, dynamic> toJson() => _$BatchModelToJson(this);

  @override
  List<Object?> get props => [id, name, startDate, endDate];
}

@JsonSerializable()
class MajorModel extends Equatable {
  final String id;
  final String name;

  const MajorModel({
    required this.id,
    required this.name,
  });

  factory MajorModel.fromJson(Map<String, dynamic> json) => 
      _$MajorModelFromJson(json);
  Map<String, dynamic> toJson() => _$MajorModelToJson(this);

  @override
  List<Object?> get props => [id, name];
}

@JsonSerializable()
class DepartmentModel extends Equatable {
  final int id;
  final String name;

  const DepartmentModel({
    required this.id,
    required this.name,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => 
      _$DepartmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);

  @override
  List<Object?> get props => [id, name];
}

@JsonSerializable()
class LecturerModel extends Equatable {
  final String id;
  @JsonKey(name: 'user_name')
  final String userName;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String email;
  final int department;
  final String title;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'department_name')
  final String? departmentName;

  const LecturerModel({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.department,
    required this.title,
    required this.isActive,
    this.departmentName,
  });

  // Helper getter để hiển thị tên đầy đủ
  String get fullName => '$firstName $lastName';

  factory LecturerModel.fromJson(Map<String, dynamic> json) => 
      _$LecturerModelFromJson(json);
  Map<String, dynamic> toJson() => _$LecturerModelToJson(this);

  @override
  List<Object?> get props => [id, userName, firstName, lastName, email, department, title, isActive, departmentName];
}
