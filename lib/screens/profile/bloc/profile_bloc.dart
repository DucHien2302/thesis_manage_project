import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/profile_models.dart';
import 'package:thesis_manage_project/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<SaveProfile>(_onSaveProfile);
  }  FutureOr<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepository.getUserProfile(event.userType);

      if (profile.containsKey('error')) {        // No profile yet - return empty profile
        if (event.userType == AppConfig.userTypeStudent) { // Student (2)
          emit(ProfileLoaded(studentProfile: StudentFullProfileModel.empty(userId: event.userId), lecturerProfile: null));
        } else if (event.userType == AppConfig.userTypeLecturer) { // Lecturer (3)
          emit(ProfileLoaded(studentProfile: null, lecturerProfile: LecturerFullProfileModel.empty(userId: event.userId)));
        } else {
          emit(const ProfileError('Loại tài khoản không được hỗ trợ'));
        }} else {
        // Profile exists
        if (event.userType == AppConfig.userTypeStudent) { // Student (2)
          final studentProfile = StudentFullProfileModel.fromJson(profile);
          emit(ProfileLoaded(studentProfile: studentProfile, lecturerProfile: null));
        } else if (event.userType == AppConfig.userTypeLecturer) { // Lecturer (3)
          final lecturerProfile = LecturerFullProfileModel.fromJson(profile);
          emit(ProfileLoaded(studentProfile: null, lecturerProfile: lecturerProfile));
        } else {
          emit(const ProfileError('Loại tài khoản không được hỗ trợ'));
        }
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
  FutureOr<void> _onSaveProfile(SaveProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileSaving());
    try {
      final result = await _profileRepository.createOrUpdateProfile(
        event.userType, 
        event.profileData,
      );

      if (result.containsKey('error')) {
        emit(ProfileError(result['error'].toString()));
      } else {
        // Don't reload profile immediately to avoid duplicate API calls
        // The ProfileScreen will handle reloading if needed
        emit(ProfileSaved());
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
