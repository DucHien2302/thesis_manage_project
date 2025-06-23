import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/repositories/lecturer_thesis_repository.dart';

part 'lecturer_thesis_event.dart';
part 'lecturer_thesis_state.dart';

class LecturerThesisBloc extends Bloc<LecturerThesisEvent, LecturerThesisState> {
  final LecturerThesisRepository _repository;

  LecturerThesisBloc({required LecturerThesisRepository repository})
      : _repository = repository,
        super(LecturerThesisInitial()) {    on<LoadLecturerTheses>(_onLoadLecturerTheses);
    on<RefreshLecturerTheses>(_onRefreshLecturerTheses);
    on<FilterLecturerTheses>(_onFilterLecturerTheses);
    on<CreateThesis>(_onCreateThesis);
  }

  Future<void> _onLoadLecturerTheses(
    LoadLecturerTheses event,
    Emitter<LecturerThesisState> emit,
  ) async {
    emit(LecturerThesisLoading());
    try {
      final theses = await _repository.getLecturerTheses();
      // Filter out "Đã đăng ký" (status 5) and "Chưa đăng ký" (status 4)
      final filteredTheses = theses.where((thesis) {
        // Parse status to check if it's registered or not registered
        return !thesis.status.contains('Đã được đăng ký') && 
               !thesis.status.contains('Chưa được đăng ký');
      }).toList();
      
      emit(LecturerThesisLoaded(
        theses: filteredTheses,
        filteredTheses: filteredTheses,
      ));
    } catch (e) {
      emit(LecturerThesisError(message: e.toString()));
    }
  }

  Future<void> _onRefreshLecturerTheses(
    RefreshLecturerTheses event,
    Emitter<LecturerThesisState> emit,
  ) async {
    try {
      final theses = await _repository.getLecturerTheses();
      // Filter out "Đã đăng ký" (status 5) and "Chưa đăng ký" (status 4)
      final filteredTheses = theses.where((thesis) {
        return !thesis.status.contains('Đã được đăng ký') && 
               !thesis.status.contains('Chưa được đăng ký');
      }).toList();
      
      emit(LecturerThesisLoaded(
        theses: filteredTheses,
        filteredTheses: filteredTheses,
      ));
    } catch (e) {
      emit(LecturerThesisError(message: e.toString()));
    }
  }

  void _onFilterLecturerTheses(
    FilterLecturerTheses event,
    Emitter<LecturerThesisState> emit,
  ) {
    if (state is LecturerThesisLoaded) {
      final currentState = state as LecturerThesisLoaded;
      List<ThesisModel> filteredTheses = currentState.theses;

      if (event.status.isNotEmpty) {
        filteredTheses = filteredTheses
            .where((thesis) => thesis.status.toLowerCase().contains(event.status.toLowerCase()))
            .toList();
      }

      if (event.searchQuery.isNotEmpty) {
        filteredTheses = filteredTheses
            .where((thesis) =>
                thesis.name.toLowerCase().contains(event.searchQuery.toLowerCase()) ||
                thesis.description.toLowerCase().contains(event.searchQuery.toLowerCase()))
            .toList();
      }

      emit(currentState.copyWith(filteredTheses: filteredTheses));
    }
  }

  Future<void> _onCreateThesis(
    CreateThesis event,
    Emitter<LecturerThesisState> emit,
  ) async {
    emit(LecturerThesisCreating());
    try {
      final thesis = await _repository.createThesis(event.thesisRequest.toJson());
      emit(LecturerThesisCreated(thesis: thesis));
      // Reload the thesis list
      add(const LoadLecturerTheses());    } catch (e) {
      emit(LecturerThesisError(message: e.toString()));
    }
  }
}
