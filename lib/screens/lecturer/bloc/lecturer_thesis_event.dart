part of 'lecturer_thesis_bloc.dart';

abstract class LecturerThesisEvent extends Equatable {
  const LecturerThesisEvent();

  @override
  List<Object> get props => [];
}

class LoadLecturerTheses extends LecturerThesisEvent {
  const LoadLecturerTheses();
}

class RefreshLecturerTheses extends LecturerThesisEvent {
  const RefreshLecturerTheses();
}

class FilterLecturerTheses extends LecturerThesisEvent {
  final String status;
  final String searchQuery;

  const FilterLecturerTheses({
    this.status = '',
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [status, searchQuery];
}

class CreateThesis extends LecturerThesisEvent {
  final ThesisCreateRequest thesisRequest;

  const CreateThesis({required this.thesisRequest});

  @override
  List<Object> get props => [thesisRequest];
}
