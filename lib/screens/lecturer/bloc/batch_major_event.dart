part of 'batch_major_bloc.dart';

abstract class BatchMajorEvent extends Equatable {
  const BatchMajorEvent();

  @override
  List<Object> get props => [];
}

class LoadBatchesAndMajors extends BatchMajorEvent {
  const LoadBatchesAndMajors();
}
