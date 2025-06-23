part of 'thesis_approval_bloc.dart';

abstract class ThesisApprovalState extends Equatable {
  const ThesisApprovalState();

  @override
  List<Object?> get props => [];
}

class ThesisApprovalInitial extends ThesisApprovalState {}

class ThesisApprovalLoading extends ThesisApprovalState {}

class ThesisApprovalLoaded extends ThesisApprovalState {
  final List<ThesisModel> theses;
  final List<ThesisModel> filteredTheses;
  final ApprovalType approvalType;

  const ThesisApprovalLoaded({
    required this.theses,
    required this.filteredTheses,
    required this.approvalType,
  });

  ThesisApprovalLoaded copyWith({
    List<ThesisModel>? theses,
    List<ThesisModel>? filteredTheses,
    ApprovalType? approvalType,
  }) {
    return ThesisApprovalLoaded(
      theses: theses ?? this.theses,
      filteredTheses: filteredTheses ?? this.filteredTheses,
      approvalType: approvalType ?? this.approvalType,
    );
  }

  @override
  List<Object> get props => [theses, filteredTheses, approvalType];
}

class ThesisApprovalProcessing extends ThesisApprovalState {}

class ThesisApprovalActionSuccess extends ThesisApprovalState {
  final String message;

  const ThesisApprovalActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ThesisApprovalBatchSuccess extends ThesisApprovalState {
  final String message;
  final ThesisBatchUpdateResponse response;

  const ThesisApprovalBatchSuccess({
    required this.message,
    required this.response,
  });

  @override
  List<Object> get props => [message, response];
}

class ThesisApprovalError extends ThesisApprovalState {
  final String message;

  const ThesisApprovalError({required this.message});

  @override
  List<Object> get props => [message];
}
