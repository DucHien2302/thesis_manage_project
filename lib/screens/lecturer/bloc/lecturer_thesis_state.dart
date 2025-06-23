part of 'lecturer_thesis_bloc.dart';

abstract class LecturerThesisState extends Equatable {
  const LecturerThesisState();

  @override
  List<Object> get props => [];
}

class LecturerThesisInitial extends LecturerThesisState {}

class LecturerThesisLoading extends LecturerThesisState {}

class LecturerThesisLoaded extends LecturerThesisState {
  final List<ThesisModel> theses;
  final List<ThesisModel> filteredTheses;

  const LecturerThesisLoaded({
    required this.theses,
    required this.filteredTheses,
  });

  LecturerThesisLoaded copyWith({
    List<ThesisModel>? theses,
    List<ThesisModel>? filteredTheses,
  }) {
    return LecturerThesisLoaded(
      theses: theses ?? this.theses,
      filteredTheses: filteredTheses ?? this.filteredTheses,
    );
  }

  @override
  List<Object> get props => [theses, filteredTheses];
}

class LecturerThesisError extends LecturerThesisState {
  final String message;

  const LecturerThesisError({required this.message});

  @override
  List<Object> get props => [message];
}
