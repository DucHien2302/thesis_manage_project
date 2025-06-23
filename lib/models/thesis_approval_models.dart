import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thesis_approval_models.g.dart';

// Request model for thesis batch update
@JsonSerializable()
class ThesisBatchUpdateRequest extends Equatable {
  final List<ThesisBatchUpdateItem> theses;

  const ThesisBatchUpdateRequest({
    required this.theses,
  });

  factory ThesisBatchUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ThesisBatchUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ThesisBatchUpdateRequestToJson(this);

  @override
  List<Object> get props => [theses];
}

@JsonSerializable()
class ThesisBatchUpdateItem extends Equatable {
  final String id;
  @JsonKey(name: 'update_data')
  final ThesisUpdateData updateData;

  const ThesisBatchUpdateItem({
    required this.id,
    required this.updateData,
  });

  factory ThesisBatchUpdateItem.fromJson(Map<String, dynamic> json) =>
      _$ThesisBatchUpdateItemFromJson(json);
  Map<String, dynamic> toJson() => _$ThesisBatchUpdateItemToJson(this);

  @override
  List<Object> get props => [id, updateData];
}

@JsonSerializable()
class ThesisUpdateData extends Equatable {
  final String? title;
  final String? description;
  @JsonKey(name: 'thesis_type')
  final int? thesisType;
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  final int? status;
  @JsonKey(name: 'batch_id')
  final String? batchId;
  @JsonKey(name: 'major_id')
  final String? majorId;
  @JsonKey(name: 'lecturer_ids')
  final List<String>? lecturerIds;
  @JsonKey(name: 'reviewer_ids')
  final List<String>? reviewerIds;
  final String? reason;
  @JsonKey(name: 'department_id')
  final int? departmentId;

  const ThesisUpdateData({
    this.title,
    this.description,
    this.thesisType,
    this.startDate,
    this.endDate,
    this.status,
    this.batchId,
    this.majorId,
    this.lecturerIds,
    this.reviewerIds,
    this.reason,
    this.departmentId,
  });

  factory ThesisUpdateData.fromJson(Map<String, dynamic> json) =>
      _$ThesisUpdateDataFromJson(json);
  Map<String, dynamic> toJson() => _$ThesisUpdateDataToJson(this);

  @override
  List<Object?> get props => [
    title,
    description,
    thesisType,
    startDate,
    endDate,
    status,
    batchId,
    majorId,
    lecturerIds,
    reviewerIds,
    reason,
    departmentId,
  ];
}

// Response model for thesis batch update
@JsonSerializable()
class ThesisBatchUpdateResponse extends Equatable {
  @JsonKey(name: 'success_count')
  final int successCount;
  final List<BatchUpdateError> errors;

  const ThesisBatchUpdateResponse({
    required this.successCount,
    required this.errors,
  });

  factory ThesisBatchUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$ThesisBatchUpdateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ThesisBatchUpdateResponseToJson(this);

  @override
  List<Object> get props => [successCount, errors];
}

@JsonSerializable()
class BatchUpdateError extends Equatable {
  final String id;
  final String error;

  const BatchUpdateError({
    required this.id,
    required this.error,
  });

  factory BatchUpdateError.fromJson(Map<String, dynamic> json) =>
      _$BatchUpdateErrorFromJson(json);
  Map<String, dynamic> toJson() => _$BatchUpdateErrorToJson(this);

  @override
  List<Object> get props => [id, error];
}

// Status constants based on the requirements
class ThesisStatus {
  static const int rejected = 0; // Từ chối
  static const int pending = 1; // Chờ duyệt
  static const int departmentApproved = 2; // Đã duyệt cấp bộ môn
  static const int facultyApproved = 3; // Đã duyệt cấp khoa
  static const int notRegistered = 4; // Chưa được đăng ký
  static const int registered = 5; // Đã được đăng ký

  static String getStatusName(int status) {
    switch (status) {
      case rejected:
        return "Từ chối";
      case pending:
        return "Chờ duyệt";
      case departmentApproved:
        return "Đã duyệt cấp bộ môn";
      case facultyApproved:
        return "Đã duyệt cấp khoa";
      case notRegistered:
        return "Chưa được đăng ký";
      case registered:
        return "Đã được đăng ký";
      default:
        return "Không xác định";
    }
  }

  static int getStatusFromString(String statusString) {
    if (statusString.contains("Từ chối")) return rejected;
    if (statusString.contains("Chờ duyệt")) return pending;
    if (statusString.contains("Đã duyệt cấp bộ môn")) return departmentApproved;
    if (statusString.contains("Đã duyệt cấp khoa")) return facultyApproved;
    if (statusString.contains("Chưa được đăng ký")) return notRegistered;
    if (statusString.contains("Đã được đăng ký")) return registered;
    return pending; // Default to pending if unknown
  }
}

// Enum for approval types
enum ApprovalType {
  department, // Duyệt cấp bộ môn
  faculty,    // Duyệt cấp khoa
}

extension ApprovalTypeExtension on ApprovalType {
  String get displayName {
    switch (this) {
      case ApprovalType.department:
        return 'Duyệt cấp bộ môn';
      case ApprovalType.faculty:
        return 'Duyệt cấp khoa';
    }
  }

  List<int> get allowedStatuses {
    switch (this) {
      case ApprovalType.department:
        return [ThesisStatus.pending, ThesisStatus.departmentApproved];
      case ApprovalType.faculty:
        return [ThesisStatus.departmentApproved, ThesisStatus.facultyApproved];
    }
  }
}
