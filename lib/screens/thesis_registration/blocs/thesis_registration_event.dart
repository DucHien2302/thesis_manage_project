part of 'thesis_registration_bloc.dart';

abstract class ThesisRegistrationEvent extends Equatable {
  const ThesisRegistrationEvent();

  @override
  List<Object?> get props => [];
}

/// Event để load danh sách đề tài theo chuyên ngành của sinh viên đang đăng nhập
class LoadThesesByMyMajor extends ThesisRegistrationEvent {
  const LoadThesesByMyMajor();

  @override
  List<Object?> get props => [];
}

/// Event để load chi tiết đề tài
class LoadThesisDetail extends ThesisRegistrationEvent {
  final String thesisId;

  const LoadThesisDetail(this.thesisId);

  @override
  List<Object> get props => [thesisId];
}

/// Event để đăng ký đề tài cho nhóm
class RegisterThesisForGroup extends ThesisRegistrationEvent {
  final String groupId;
  final String thesisId;

  const RegisterThesisForGroup({
    required this.groupId,
    required this.thesisId,
  });

  @override
  List<Object> get props => [groupId, thesisId];
}

/// Event để load danh sách đăng ký của sinh viên
class LoadStudentRegistrations extends ThesisRegistrationEvent {
  final String studentId;

  const LoadStudentRegistrations(this.studentId);

  @override
  List<Object> get props => [studentId];
}

/// Event để hủy đăng ký đề tài
class CancelRegistration extends ThesisRegistrationEvent {
  final String registrationId;

  const CancelRegistration(this.registrationId);

  @override
  List<Object> get props => [registrationId];
}

/// Event để search đề tài
class SearchTheses extends ThesisRegistrationEvent {
  final String majorId;
  final String query;

  const SearchTheses({
    required this.majorId,
    required this.query,
  });

  @override
  List<Object> get props => [majorId, query];
}

/// Event để reset search
class ResetSearch extends ThesisRegistrationEvent {
  const ResetSearch();
}

/// Event để load danh sách nhóm của sinh viên
class LoadMyGroups extends ThesisRegistrationEvent {
  const LoadMyGroups();

  @override
  List<Object> get props => [];
}

/// Event để refresh danh sách đề tài
class RefreshTheses extends ThesisRegistrationEvent {
  const RefreshTheses();

  @override
  List<Object> get props => [];
}
