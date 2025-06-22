import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/services/thesis_service.dart';

part 'thesis_registration_event.dart';
part 'thesis_registration_state.dart';

class ThesisRegistrationBloc extends Bloc<ThesisRegistrationEvent, ThesisRegistrationState> {
  final ThesisService _thesisService;

  ThesisRegistrationBloc({
    ThesisService? thesisService,
  }) : _thesisService = thesisService ?? ThesisService(),
       super(const ThesisRegistrationInitial()) {
    
    on<LoadThesesByMyMajor>(_onLoadThesesByMyMajor);
    on<LoadThesisDetail>(_onLoadThesisDetail);
    on<RegisterThesisForGroup>(_onRegisterThesisForGroup);
    on<LoadMyGroups>(_onLoadMyGroups);
    on<RefreshTheses>(_onRefreshTheses);
    on<LoadStudentRegistrations>(_onLoadStudentRegistrations);
  }

  /// Xử lý event load danh sách đề tài theo chuyên ngành của sinh viên đang đăng nhập
  Future<void> _onLoadThesesByMyMajor(
    LoadThesesByMyMajor event,
    Emitter<ThesisRegistrationState> emit,
  ) async {
    try {
      emit(const ThesesLoading());

      final theses = await _thesisService.getThesesByMyMajor();

      emit(ThesesLoaded(theses: theses));
    } catch (e) {
      emit(ThesesError(e.toString()));
    }
  }

  /// Xử lý event load chi tiết đề tài
  Future<void> _onLoadThesisDetail(
    LoadThesisDetail event,
    Emitter<ThesisRegistrationState> emit,
  ) async {
    try {
      emit(const ThesisDetailLoading());

      final thesis = await _thesisService.getThesisDetail(event.thesisId);

      emit(ThesisDetailLoaded(thesis));
    } catch (e) {
      emit(ThesisDetailError(e.toString()));
    }
  }

  /// Xử lý event đăng ký đề tài cho nhóm
  Future<void> _onRegisterThesisForGroup(
    RegisterThesisForGroup event,
    Emitter<ThesisRegistrationState> emit,
  ) async {
    try {
      emit(const ThesisRegistering());

      await _thesisService.registerThesisForGroup(
        event.groupId,
        event.thesisId,
      );

      emit(const ThesisRegistrationSuccess(
        message: 'Đăng ký đề tài thành công!',
      ));
    } catch (e) {
      emit(ThesisRegistrationError(e.toString()));
    }
  }

  /// Xử lý event load danh sách nhóm
  Future<void> _onLoadMyGroups(
    LoadMyGroups event,
    Emitter<ThesisRegistrationState> emit,
  ) async {
    try {
      emit(const GroupsLoading());

      final groups = await _thesisService.getMyGroups();

      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  /// Xử lý event refresh danh sách đề tài
  Future<void> _onRefreshTheses(
    RefreshTheses event,
    Emitter<ThesisRegistrationState> emit,
  ) async {
    add(const LoadThesesByMyMajor());
  }  /// Xử lý event load danh sách đăng ký của sinh viên
  Future<void> _onLoadStudentRegistrations(
    LoadStudentRegistrations event,
    Emitter<ThesisRegistrationState> emit,
  ) async {
    try {
      emit(const StudentRegistrationsLoading());
      // Instead of using getStudentRegistrations (which is misleading),
      // we should use getThesisDetail directly with a proper thesis ID
      // This is temporary until we implement proper student thesis registration lookup
      // In this case, event.studentId would actually contain a thesis ID
      final thesis = await _thesisService.getThesisDetail(event.studentId);
      emit(ThesisDetailLoaded(thesis));
    } catch (e) {
      emit(StudentRegistrationsError(e.toString()));
    }
  }
}
