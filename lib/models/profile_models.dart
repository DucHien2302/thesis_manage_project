import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_models.g.dart';

@JsonSerializable()
class InformationModel extends Equatable {
  final String? id;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'date_of_birth')
  final DateTime dateOfBirth;
  final int gender;
  final String address;
  @JsonKey(name: 'tel_phone')
  final String telPhone;

  const InformationModel({
    this.id,
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.telPhone,
  });

  factory InformationModel.fromJson(Map<String, dynamic> json) => _$InformationModelFromJson(json);
  Map<String, dynamic> toJson() => _$InformationModelToJson(this);

  // Create a copy of this InformationModel with the given fields replaced
  InformationModel copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    int? gender,
    String? address,
    String? telPhone,
  }) {
    return InformationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      telPhone: telPhone ?? this.telPhone,
    );
  }

  // Create empty information model with default values
  factory InformationModel.empty() => InformationModel(
    firstName: '',
    lastName: '',
    dateOfBirth: DateTime(1970, 1, 1),
    gender: 0,
    address: '',
    telPhone: '',
  );

  @override
  List<Object?> get props => [id, userId, firstName, lastName, dateOfBirth, gender, address, telPhone];
}

@JsonSerializable()
class StudentInfoModel extends Equatable {
  final String? id;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'student_code')
  final String studentCode;
  @JsonKey(name: 'class_name')
  final String? className;
  @JsonKey(name: 'major_id')
  final String majorId;
  @JsonKey(name: 'major_name')
  final String? majorName;
  @JsonKey(name: 'create_datetime')
  final DateTime? createDatetime;
  @JsonKey(name: 'update_datetime')
  final DateTime? updateDatetime;

  const StudentInfoModel({
    this.id,
    this.userId,
    required this.studentCode,
    this.className,
    required this.majorId,
    this.majorName,
    this.createDatetime,
    this.updateDatetime,
  });

  factory StudentInfoModel.fromJson(Map<String, dynamic> json) => _$StudentInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentInfoModelToJson(this);

  // Create a copy of this StudentInfoModel with the given fields replaced
  StudentInfoModel copyWith({
    String? id,
    String? userId,
    String? studentCode,
    String? className,
    String? majorId,
    String? majorName,
    DateTime? createDatetime,
    DateTime? updateDatetime,
  }) {
    return StudentInfoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      studentCode: studentCode ?? this.studentCode,
      className: className ?? this.className,
      majorId: majorId ?? this.majorId,
      majorName: majorName ?? this.majorName,
      createDatetime: createDatetime ?? this.createDatetime,
      updateDatetime: updateDatetime ?? this.updateDatetime,
    );
  }

  // Create empty student info model with default values
  factory StudentInfoModel.empty() => StudentInfoModel(
    studentCode: '',
    majorId: '',
  );

  @override
  List<Object?> get props => [id, userId, studentCode, className, majorId, majorName, createDatetime, updateDatetime];
}

@JsonSerializable()
class LecturerInfoModel extends Equatable {
  final String? id;
  final String? userId;
  final String lecturerCode;
  final int department;
  final String title;
  final String email;
  final String? departmentName;
  final DateTime? createDatetime;
  final DateTime? updateDatetime;

  const LecturerInfoModel({
    this.id,
    this.userId,
    required this.lecturerCode,
    required this.department,
    required this.title,
    required this.email,
    this.departmentName,
    this.createDatetime,
    this.updateDatetime,
  });

  factory LecturerInfoModel.fromJson(Map<String, dynamic> json) => _$LecturerInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$LecturerInfoModelToJson(this);

  // Create a copy of this LecturerInfoModel with the given fields replaced
  LecturerInfoModel copyWith({
    String? id,
    String? userId,
    String? lecturerCode,
    int? department,
    String? title,
    String? email,
    String? departmentName,
    DateTime? createDatetime,
    DateTime? updateDatetime,
  }) {
    return LecturerInfoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lecturerCode: lecturerCode ?? this.lecturerCode,
      department: department ?? this.department,
      title: title ?? this.title,
      email: email ?? this.email,
      departmentName: departmentName ?? this.departmentName,
      createDatetime: createDatetime ?? this.createDatetime,
      updateDatetime: updateDatetime ?? this.updateDatetime,
    );
  }

  // Create empty lecturer info model with default values
  factory LecturerInfoModel.empty() => LecturerInfoModel(
    lecturerCode: '',
    department: 1,
    title: '',
    email: '',
  );

  @override
  List<Object?> get props => [id, userId, lecturerCode, department, title, email, departmentName, createDatetime, updateDatetime];
}

@JsonSerializable()
class StudentFullProfileModel extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'user_name')
  final String userName;
  final InformationModel information;
  @JsonKey(name: 'student_info')
  final StudentInfoModel studentInfo;

  const StudentFullProfileModel({
    required this.userId,
    required this.userName,
    required this.information,
    required this.studentInfo,
  });

  factory StudentFullProfileModel.fromJson(Map<String, dynamic> json) => _$StudentFullProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentFullProfileModelToJson(this);

  // Create a copy of this StudentFullProfileModel with the given fields replaced
  StudentFullProfileModel copyWith({
    String? userId,
    String? userName,
    InformationModel? information,
    StudentInfoModel? studentInfo,
  }) {
    return StudentFullProfileModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      information: information ?? this.information,
      studentInfo: studentInfo ?? this.studentInfo,
    );
  }

  // Create empty student full profile model with default values
  factory StudentFullProfileModel.empty({String userId = '', String userName = ''}) => StudentFullProfileModel(
    userId: userId,
    userName: userName,
    information: InformationModel.empty(),
    studentInfo: StudentInfoModel.empty(),
  );

  @override
  List<Object> get props => [userId, userName, information, studentInfo];
}

@JsonSerializable()
class LecturerFullProfileModel extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  final InformationModel information;
  final LecturerInfoModel lecturerInfo;

  const LecturerFullProfileModel({
    required this.userId,
    required this.information,
    required this.lecturerInfo,
  });

  factory LecturerFullProfileModel.fromJson(Map<String, dynamic> json) => _$LecturerFullProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$LecturerFullProfileModelToJson(this);

  // Create a copy of this LecturerFullProfileModel with the given fields replaced
  LecturerFullProfileModel copyWith({
    String? userId,
    InformationModel? information,
    LecturerInfoModel? lecturerInfo,
  }) {
    return LecturerFullProfileModel(
      userId: userId ?? this.userId,
      information: information ?? this.information,
      lecturerInfo: lecturerInfo ?? this.lecturerInfo,
    );
  }

  // Create empty lecturer full profile model with default values
  factory LecturerFullProfileModel.empty({String userId = ''}) => LecturerFullProfileModel(
    userId: userId,
    information: InformationModel.empty(),
    lecturerInfo: LecturerInfoModel.empty(),
  );

  @override
  List<Object> get props => [userId, information, lecturerInfo];
}

// Helper classes for request payloads
class StudentCreateProfile {
  final Map<String, dynamic> information;
  final Map<String, dynamic> studentInfo;

  StudentCreateProfile({
    required this.information,
    required this.studentInfo,
  });

  Map<String, dynamic> toJson() => {
    'information': information,
    'student_info': studentInfo,
  };
}

class LecturerCreateProfile {
  final Map<String, dynamic> information;
  final Map<String, dynamic> lecturerInfo;

  LecturerCreateProfile({
    required this.information,
    required this.lecturerInfo,
  });

  Map<String, dynamic> toJson() => {
    'information': information,
    'lecturer_info': lecturerInfo,
  };
}
