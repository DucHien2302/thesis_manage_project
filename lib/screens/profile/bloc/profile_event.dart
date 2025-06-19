part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final int userType;
  final String userId;

  const LoadProfile({
    required this.userType,
    required this.userId,
  });

  @override
  List<Object> get props => [userType, userId];
}

class SaveProfile extends ProfileEvent {
  final int userType;
  final String userId;
  final Map<String, dynamic> profileData;

  const SaveProfile({
    required this.userType,
    required this.userId,
    required this.profileData,
  });

  @override
  List<Object> get props => [userType, userId, profileData];
}
