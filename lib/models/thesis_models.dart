import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thesis_models.g.dart';

// Supporting models từ API
@JsonSerializable()
class InstructorResponse extends Equatable {
  final String name;
  final String email;
  @JsonKey(name: 'lecturer_code')
  final String lecturerCode;
  final int department;
  @JsonKey(name: 'department_name')
  final String? departmentName;

  const InstructorResponse({
    required this.name,
    required this.email,
    required this.lecturerCode,
    required this.department,
    this.departmentName,
  });

  factory InstructorResponse.fromJson(Map<String, dynamic> json) => 
      _$InstructorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InstructorResponseToJson(this);

  @override
  List<Object?> get props => [name, email, lecturerCode, department, departmentName];
}

@JsonSerializable()
class BatchResponse extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  final SemesterResponse semester;

  const BatchResponse({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.semester,
  });

  factory BatchResponse.fromJson(Map<String, dynamic> json) => 
      _$BatchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BatchResponseToJson(this);

  @override
  List<Object?> get props => [id, name, startDate, endDate, semester];
}

// AcademyYearResponse model
@JsonSerializable()
class AcademyYearResponse extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;

  const AcademyYearResponse({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  factory AcademyYearResponse.fromJson(Map<String, dynamic> json) => 
      _$AcademyYearResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AcademyYearResponseToJson(this);

  @override
  List<Object?> get props => [id, name, startDate, endDate];
}

// Update SemesterResponse to include academy_year
@JsonSerializable()
class SemesterResponse extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  @JsonKey(name: 'academy_year')
  final AcademyYearResponse? academyYear;

  const SemesterResponse({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.academyYear,
  });

  factory SemesterResponse.fromJson(Map<String, dynamic> json) => 
      _$SemesterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SemesterResponseToJson(this);

  @override
  List<Object?> get props => [id, name, startDate, endDate, academyYear];
}

// Updated DepartmentResponse to match API (id is int)
@JsonSerializable()
class DepartmentResponse extends Equatable {
  final int id;
  final String name;

  const DepartmentResponse({
    required this.id,
    required this.name,
  });

  factory DepartmentResponse.fromJson(Map<String, dynamic> json) => 
      _$DepartmentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentResponseToJson(this);

  @override
  List<Object?> get props => [id, name];
}

// Full ThesisModel matching the complete API response
@JsonSerializable()
class ThesisModel extends Equatable {
  final String id;
  @JsonKey(name: 'thesis_type')
  final int thesisType;
  final String status;
  final String name;
  final String description;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  final List<InstructorResponse> instructors;
  final List<InstructorResponse> reviewers;
  final BatchResponse batch;
  final String major;
  final DepartmentResponse? department;
  final String? reason;
  @JsonKey(name: 'name_thesis_type')
  final String nameThesisType;
  final String? notes;
  @JsonKey(name: 'committee_id')
  final String? committeeId;

  const ThesisModel({
    required this.id,
    required this.thesisType,
    required this.status,
    required this.name,
    required this.description,
    this.startDate,
    this.endDate,
    required this.instructors,
    required this.reviewers,
    required this.batch,
    required this.major,
    this.department,
    this.reason,
    required this.nameThesisType,
    this.notes,
    this.committeeId,
  });

  factory ThesisModel.fromJson(Map<String, dynamic> json) => 
      _$ThesisModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThesisModelToJson(this);

  // Helper getters for UI compatibility
  String get title => name;
  String? get lecturerName => instructors.isNotEmpty ? instructors.first.name : null;
  String? get majorName => major;
  bool get isActive => status.toLowerCase().contains('chưa được đăng ký') || 
                       status.toLowerCase().contains('active') ||
                       status.toLowerCase().contains('approved');
  
  bool get isRegistrationOpen => isActive;

  String get thesisTypeName => nameThesisType;

  @override
  List<Object?> get props => [
    id, thesisType, status, name, description, startDate, endDate,
    instructors, reviewers, batch, major, department, reason,
    nameThesisType, notes, committeeId
  ];
}

@JsonSerializable()
class StudentThesisRegistrationRequest extends Equatable {
  @JsonKey(name: 'student_id')
  final String studentId;
  @JsonKey(name: 'thesis_id')
  final String thesisId;
  final String? notes;

  const StudentThesisRegistrationRequest({
    required this.studentId,
    required this.thesisId,
    this.notes,
  });

  factory StudentThesisRegistrationRequest.fromJson(Map<String, dynamic> json) => 
      _$StudentThesisRegistrationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StudentThesisRegistrationRequestToJson(this);

  @override
  List<Object?> get props => [studentId, thesisId, notes];
}

@JsonSerializable()
class StudentThesisRegistrationModel extends Equatable {
  final String id;
  @JsonKey(name: 'student_id')
  final String studentId;
  @JsonKey(name: 'thesis_id')
  final String thesisId;
  final String status;
  final String? notes;
  @JsonKey(name: 'registration_date')
  final String registrationDate;
  @JsonKey(name: 'approval_date')
  final String? approvalDate;
  @JsonKey(name: 'create_datetime')
  final String createDatetime;
  @JsonKey(name: 'update_datetime')
  final String updateDatetime;

  const StudentThesisRegistrationModel({
    required this.id,
    required this.studentId,
    required this.thesisId,
    required this.status,
    this.notes,
    required this.registrationDate,
    this.approvalDate,
    required this.createDatetime,
    required this.updateDatetime,
  });

  factory StudentThesisRegistrationModel.fromJson(Map<String, dynamic> json) => 
      _$StudentThesisRegistrationModelFromJson(json);
  Map<String, dynamic> toJson() => _$StudentThesisRegistrationModelToJson(this);

  String get statusName {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Chờ duyệt';
      case 'approved':
        return 'Đã duyệt';
      case 'rejected':
        return 'Từ chối';
      default:
        return status;
    }
  }

  @override
  List<Object?> get props => [
    id, studentId, thesisId, status, notes, registrationDate,
    approvalDate, createDatetime, updateDatetime
  ];
}

@JsonSerializable()
class ThesisListResponse extends Equatable {
  final List<ThesisModel> data;
  final int total;
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'last_page')
  final int lastPage;

  const ThesisListResponse({
    required this.data,
    required this.total,
    required this.currentPage,
    required this.perPage,
    required this.lastPage,
  });

  factory ThesisListResponse.fromJson(Map<String, dynamic> json) => 
      _$ThesisListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ThesisListResponseToJson(this);

  @override
  List<Object> get props => [data, total, currentPage, perPage, lastPage];
}

@JsonSerializable()
class GroupMemberModel extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'student_code')
  final String studentCode;
  @JsonKey(name: 'is_leader')
  final bool isLeader;

  const GroupMemberModel({
    required this.userId,
    required this.fullName,
    required this.studentCode,
    required this.isLeader,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) => 
      _$GroupMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);

  @override
  List<Object> get props => [userId, fullName, studentCode, isLeader];
}

@JsonSerializable()
class GroupModel extends Equatable {
  final String id;
  final String? name;
  @JsonKey(name: 'leader_id')
  final String leaderId;
  @JsonKey(name: 'thesis_id')
  final String? thesisId;
  final List<GroupMemberModel> members;

  const GroupModel({
    required this.id,
    this.name,
    required this.leaderId,
    this.thesisId,
    required this.members,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => 
      _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  @override
  List<Object?> get props => [id, name, leaderId, thesisId, members];
}
