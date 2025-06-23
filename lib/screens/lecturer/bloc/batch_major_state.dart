part of 'batch_major_bloc.dart';

abstract class BatchMajorState extends Equatable {
  const BatchMajorState();

  @override
  List<Object> get props => [];
}

class BatchMajorInitial extends BatchMajorState {}

class BatchMajorLoading extends BatchMajorState {}

class BatchMajorLoaded extends BatchMajorState {
  final List<BatchModel> batches;
  final List<MajorModel> majors;
  final List<DepartmentModel> departments;
  final List<LecturerModel> lecturers;

  const BatchMajorLoaded({
    required this.batches,
    required this.majors,
    required this.departments,
    required this.lecturers,
  });

  @override
  List<Object> get props => [batches, majors, departments, lecturers];
}

class BatchMajorError extends BatchMajorState {
  final String message;

  const BatchMajorError({required this.message});

  @override
  List<Object> get props => [message];
}
