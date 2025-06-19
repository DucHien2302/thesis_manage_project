part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSaving extends ProfileState {}

class ProfileSaved extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final StudentFullProfileModel? studentProfile;
  final LecturerFullProfileModel? lecturerProfile;

  const ProfileLoaded({
    this.studentProfile,
    this.lecturerProfile,
  });

  @override
  List<Object?> get props => [studentProfile, lecturerProfile];

  bool get isStudent => studentProfile != null;
  bool get isLecturer => lecturerProfile != null;
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
