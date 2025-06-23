part of 'thesis_approval_bloc.dart';

abstract class ThesisApprovalEvent extends Equatable {
  const ThesisApprovalEvent();

  @override
  List<Object?> get props => [];
}

class LoadThesesForApproval extends ThesisApprovalEvent {
  final ApprovalType approvalType;

  const LoadThesesForApproval(this.approvalType);

  @override
  List<Object> get props => [approvalType];
}

class ApproveThesis extends ThesisApprovalEvent {
  final String thesisId;
  final int newStatus;
  final String? reason;

  const ApproveThesis({
    required this.thesisId,
    required this.newStatus,
    this.reason,
  });

  @override
  List<Object?> get props => [thesisId, newStatus, reason];
}

class RejectThesis extends ThesisApprovalEvent {
  final String thesisId;
  final String reason;

  const RejectThesis({
    required this.thesisId,
    required this.reason,
  });

  @override
  List<Object> get props => [thesisId, reason];
}

class BatchApproveTheses extends ThesisApprovalEvent {
  final List<String> thesisIds;
  final int newStatus;
  final String? reason;

  const BatchApproveTheses({
    required this.thesisIds,
    required this.newStatus,
    this.reason,
  });

  @override
  List<Object?> get props => [thesisIds, newStatus, reason];
}

class BatchRejectTheses extends ThesisApprovalEvent {
  final List<String> thesisIds;
  final String reason;

  const BatchRejectTheses({
    required this.thesisIds,
    required this.reason,
  });

  @override
  List<Object> get props => [thesisIds, reason];
}

class FilterTheses extends ThesisApprovalEvent {
  final String searchQuery;
  final String statusFilter;

  const FilterTheses({
    this.searchQuery = '',
    this.statusFilter = '',
  });

  @override
  List<Object> get props => [searchQuery, statusFilter];
}

class RefreshTheses extends ThesisApprovalEvent {
  const RefreshTheses();
}
