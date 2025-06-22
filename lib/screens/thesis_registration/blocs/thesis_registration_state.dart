part of 'thesis_registration_bloc.dart';

abstract class ThesisRegistrationState extends Equatable {
  const ThesisRegistrationState();

  @override
  List<Object?> get props => [];
}

/// State ban đầu
class ThesisRegistrationInitial extends ThesisRegistrationState {
  const ThesisRegistrationInitial();
}

/// State đang loading danh sách đề tài
class ThesesLoading extends ThesisRegistrationState {
  const ThesesLoading();
}

/// State đã load thành công danh sách đề tài
class ThesesLoaded extends ThesisRegistrationState {
  final List<ThesisModel> theses;

  const ThesesLoaded({
    required this.theses,
  });

  @override
  List<Object?> get props => [theses];

  ThesesLoaded copyWith({
    List<ThesisModel>? theses,
  }) {
    return ThesesLoaded(
      theses: theses ?? this.theses,
    );
  }
}

/// State lỗi khi load danh sách đề tài
class ThesesError extends ThesisRegistrationState {
  final String message;

  const ThesesError(this.message);

  @override
  List<Object> get props => [message];
}

/// State đang loading danh sách nhóm
class GroupsLoading extends ThesisRegistrationState {
  const GroupsLoading();
}

/// State đã load thành công danh sách nhóm
class GroupsLoaded extends ThesisRegistrationState {
  final List<GroupModel> groups;

  const GroupsLoaded(this.groups);

  @override
  List<Object> get props => [groups];
}

/// State lỗi khi load danh sách nhóm
class GroupsError extends ThesisRegistrationState {
  final String message;

  const GroupsError(this.message);

  @override
  List<Object> get props => [message];
}

/// State đang loading chi tiết đề tài
class ThesisDetailLoading extends ThesisRegistrationState {
  const ThesisDetailLoading();
}

/// State đã load thành công chi tiết đề tài
class ThesisDetailLoaded extends ThesisRegistrationState {
  final ThesisModel thesis;

  const ThesisDetailLoaded(this.thesis);

  @override
  List<Object> get props => [thesis];
}

/// State lỗi khi load chi tiết đề tài
class ThesisDetailError extends ThesisRegistrationState {
  final String message;

  const ThesisDetailError(this.message);

  @override
  List<Object> get props => [message];
}

/// State đang đăng ký đề tài
class ThesisRegistering extends ThesisRegistrationState {
  const ThesisRegistering();
}

/// State đăng ký đề tài thành công
class ThesisRegistrationSuccess extends ThesisRegistrationState {
  final String message;

  const ThesisRegistrationSuccess({
    this.message = 'Đăng ký đề tài thành công',
  });

  @override
  List<Object> get props => [message];
}

/// State lỗi khi đăng ký đề tài
class ThesisRegistrationError extends ThesisRegistrationState {
  final String message;

  const ThesisRegistrationError(this.message);

  @override
  List<Object> get props => [message];
}

/// State đang load danh sách đăng ký của sinh viên
class StudentRegistrationsLoading extends ThesisRegistrationState {
  const StudentRegistrationsLoading();
}

/// State đã load thành công danh sách đăng ký của sinh viên
class StudentRegistrationsLoaded extends ThesisRegistrationState {
  final List<StudentThesisRegistrationModel> registrations;

  const StudentRegistrationsLoaded(this.registrations);

  @override
  List<Object> get props => [registrations];
}

/// State lỗi khi load danh sách đăng ký của sinh viên
class StudentRegistrationsError extends ThesisRegistrationState {
  final String message;

  const StudentRegistrationsError(this.message);

  @override
  List<Object> get props => [message];
}

/// State đang hủy đăng ký
class RegistrationCancelling extends ThesisRegistrationState {
  const RegistrationCancelling();
}

/// State hủy đăng ký thành công
class RegistrationCancelSuccess extends ThesisRegistrationState {
  final String message;

  const RegistrationCancelSuccess({
    this.message = 'Hủy đăng ký thành công',
  });

  @override
  List<Object> get props => [message];
}

/// State lỗi khi hủy đăng ký
class RegistrationCancelError extends ThesisRegistrationState {
  final String message;

  const RegistrationCancelError(this.message);

  @override
  List<Object> get props => [message];
}

/// State đang loading danh sách đăng ký của sinh viên
class RegistrationsLoading extends ThesisRegistrationState {
  const RegistrationsLoading();
}

/// State đã load thành công danh sách đăng ký của sinh viên
class RegistrationsLoaded extends ThesisRegistrationState {
  final List<dynamic> registrations; // Sử dụng dynamic vì chưa có model cụ thể

  const RegistrationsLoaded({required this.registrations});

  @override
  List<Object> get props => [registrations];
}

/// State lỗi khi load danh sách đăng ký của sinh viên
class RegistrationsError extends ThesisRegistrationState {
  final String message;

  const RegistrationsError(this.message);

  @override
  List<Object> get props => [message];
}
