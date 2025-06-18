import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_models.g.dart';

@JsonSerializable()
class StudentModel extends Equatable {
  final String id;
  final String fullName;
  final String studentCode;
  final String? major;
  final String? email;
  final String? phone;
  final String? avatarUrl;

  const StudentModel({
    required this.id,
    required this.fullName,
    required this.studentCode,
    this.major,
    this.email,
    this.phone,
    this.avatarUrl,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentModelToJson(this);

  @override
  List<Object?> get props => [id, fullName, studentCode, major, email, phone, avatarUrl];
}
