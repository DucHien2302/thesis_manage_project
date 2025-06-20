import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_models.g.dart';

@JsonSerializable()
class StudentModel extends Equatable {
  @JsonKey(name: 'user_id')
  final String id;
  @JsonKey(name: 'user_name')
  final String userName;
  final InformationModel information;
  @JsonKey(name: 'student_info')
  final StudentInfoModel studentInfo;

  const StudentModel({
    required this.id,
    required this.userName,
    required this.information,
    required this.studentInfo,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentModelToJson(this);

  String get fullName => '${information.firstName} ${information.lastName}';
  String get studentCode => studentInfo.studentCode;
  String get majorName => studentInfo.majorName;

  @override
  List<Object?> get props => [id, userName, information, studentInfo];
}

@JsonSerializable()
class InformationModel extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'date_of_birth')
  final String dateOfBirth;
  final int gender;
  final String address;
  @JsonKey(name: 'tel_phone')
  final String telPhone;

  const InformationModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.telPhone,
  });

  factory InformationModel.fromJson(Map<String, dynamic> json) => _$InformationModelFromJson(json);
  Map<String, dynamic> toJson() => _$InformationModelToJson(this);

  @override
  List<Object?> get props => [id, userId, firstName, lastName, dateOfBirth, gender, address, telPhone];
}

@JsonSerializable()
class StudentInfoModel extends Equatable {
  @JsonKey(name: 'student_code')
  final String studentCode;
  @JsonKey(name: 'class_name')
  final String? className;
  @JsonKey(name: 'major_id')
  final String majorId;
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'create_datetime')
  final String createDatetime;
  @JsonKey(name: 'update_datetime')
  final String updateDatetime;
  @JsonKey(name: 'major_name')
  final String majorName;

  const StudentInfoModel({
    required this.studentCode,
    this.className,
    required this.majorId,
    required this.id,
    required this.userId,
    required this.createDatetime,
    required this.updateDatetime,
    required this.majorName,
  });

  factory StudentInfoModel.fromJson(Map<String, dynamic> json) => _$StudentInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentInfoModelToJson(this);

  @override
  List<Object?> get props => [studentCode, className, majorId, id, userId, createDatetime, updateDatetime, majorName];
}
