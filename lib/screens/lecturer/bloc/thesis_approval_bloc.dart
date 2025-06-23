import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/models/thesis_approval_models.dart';
import 'package:thesis_manage_project/repositories/thesis_approval_repository.dart';

part 'thesis_approval_event.dart';
part 'thesis_approval_state.dart';

class ThesisApprovalBloc extends Bloc<ThesisApprovalEvent, ThesisApprovalState> {
  final ThesisApprovalRepository _repository;

  ThesisApprovalBloc({required ThesisApprovalRepository repository})
      : _repository = repository,
        super(ThesisApprovalInitial()) {
    
    on<LoadThesesForApproval>(_onLoadThesesForApproval);
    on<ApproveThesis>(_onApproveThesis);
    on<RejectThesis>(_onRejectThesis);
    on<BatchApproveTheses>(_onBatchApproveTheses);
    on<BatchRejectTheses>(_onBatchRejectTheses);
    on<FilterTheses>(_onFilterTheses);
    on<RefreshTheses>(_onRefreshTheses);
  }

  Future<void> _onLoadThesesForApproval(
    LoadThesesForApproval event,
    Emitter<ThesisApprovalState> emit,
  ) async {
    emit(ThesisApprovalLoading());
    try {
      final theses = await _repository.getThesesForApproval(event.approvalType);
      
      emit(ThesisApprovalLoaded(
        theses: theses,
        filteredTheses: theses,
        approvalType: event.approvalType,
      ));
    } catch (e) {
      emit(ThesisApprovalError(message: e.toString()));
    }
  }

  Future<void> _onApproveThesis(
    ApproveThesis event,
    Emitter<ThesisApprovalState> emit,
  ) async {
    emit(ThesisApprovalProcessing());
    try {
      await _repository.approveThesis(
        event.thesisId, 
        event.newStatus,
        reason: event.reason,
      );
      
      emit(ThesisApprovalActionSuccess(
        message: 'Duyệt đề tài thành công!',
      ));
      
      // Reload the list
      if (state is ThesisApprovalLoaded) {
        final currentState = state as ThesisApprovalLoaded;
        add(LoadThesesForApproval(currentState.approvalType));
      }
    } catch (e) {
      emit(ThesisApprovalError(message: e.toString()));
    }
  }

  Future<void> _onRejectThesis(
    RejectThesis event,
    Emitter<ThesisApprovalState> emit,
  ) async {
    emit(ThesisApprovalProcessing());
    try {
      await _repository.rejectThesis(event.thesisId, event.reason);
      
      emit(ThesisApprovalActionSuccess(
        message: 'Từ chối đề tài thành công!',
      ));
      
      // Reload the list
      if (state is ThesisApprovalLoaded) {
        final currentState = state as ThesisApprovalLoaded;
        add(LoadThesesForApproval(currentState.approvalType));
      }
    } catch (e) {
      emit(ThesisApprovalError(message: e.toString()));
    }
  }

  Future<void> _onBatchApproveTheses(
    BatchApproveTheses event,
    Emitter<ThesisApprovalState> emit,
  ) async {
    emit(ThesisApprovalProcessing());
    try {
      final response = await _repository.batchApproveTheses(
        event.thesisIds,
        event.newStatus,
        reason: event.reason,
      );
      
      String message = 'Duyệt ${response.successCount} đề tài thành công!';
      if (response.errors.isNotEmpty) {
        message += ' ${response.errors.length} đề tài gặp lỗi.';
      }
      
      emit(ThesisApprovalBatchSuccess(
        message: message,
        response: response,
      ));
      
      // Reload the list
      if (state is ThesisApprovalLoaded) {
        final currentState = state as ThesisApprovalLoaded;
        add(LoadThesesForApproval(currentState.approvalType));
      }
    } catch (e) {
      emit(ThesisApprovalError(message: e.toString()));
    }
  }

  Future<void> _onBatchRejectTheses(
    BatchRejectTheses event,
    Emitter<ThesisApprovalState> emit,
  ) async {
    emit(ThesisApprovalProcessing());
    try {
      final response = await _repository.batchRejectTheses(
        event.thesisIds,
        event.reason,
      );
      
      String message = 'Từ chối ${response.successCount} đề tài thành công!';
      if (response.errors.isNotEmpty) {
        message += ' ${response.errors.length} đề tài gặp lỗi.';
      }
      
      emit(ThesisApprovalBatchSuccess(
        message: message,
        response: response,
      ));
      
      // Reload the list
      if (state is ThesisApprovalLoaded) {
        final currentState = state as ThesisApprovalLoaded;
        add(LoadThesesForApproval(currentState.approvalType));
      }
    } catch (e) {
      emit(ThesisApprovalError(message: e.toString()));
    }
  }

  void _onFilterTheses(
    FilterTheses event,
    Emitter<ThesisApprovalState> emit,
  ) {
    if (state is ThesisApprovalLoaded) {
      final currentState = state as ThesisApprovalLoaded;
      List<ThesisModel> filteredTheses = currentState.theses;

      if (event.searchQuery.isNotEmpty) {
        filteredTheses = filteredTheses.where((thesis) =>
          thesis.name.toLowerCase().contains(event.searchQuery.toLowerCase()) ||
          thesis.description.toLowerCase().contains(event.searchQuery.toLowerCase()) ||
          (thesis.instructors.isNotEmpty && 
           thesis.instructors.any((instructor) => 
             instructor.name.toLowerCase().contains(event.searchQuery.toLowerCase())))
        ).toList();
      }

      if (event.statusFilter.isNotEmpty) {
        filteredTheses = filteredTheses.where((thesis) =>
          thesis.status.toLowerCase().contains(event.statusFilter.toLowerCase())
        ).toList();
      }

      emit(currentState.copyWith(filteredTheses: filteredTheses));
    }
  }

  Future<void> _onRefreshTheses(
    RefreshTheses event,
    Emitter<ThesisApprovalState> emit,
  ) async {
    if (state is ThesisApprovalLoaded) {
      final currentState = state as ThesisApprovalLoaded;
      add(LoadThesesForApproval(currentState.approvalType));
    }
  }
}
