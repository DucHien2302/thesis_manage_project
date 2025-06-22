import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/repositories/thesis_repository.dart';

// Events
abstract class ThesisEvent extends Equatable {
  const ThesisEvent();

  @override
  List<Object?> get props => [];
}

class GetAllThesisEvent extends ThesisEvent {}

class GetAvailableThesisEvent extends ThesisEvent {}

class GetThesisByIdEvent extends ThesisEvent {
  final String thesisId;

  const GetThesisByIdEvent({required this.thesisId});

  @override
  List<Object?> get props => [thesisId];
}

class SearchThesisEvent extends ThesisEvent {
  final String query;

  const SearchThesisEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class GetThesisByInstructorEvent extends ThesisEvent {
  final String instructorId;

  const GetThesisByInstructorEvent({required this.instructorId});

  @override
  List<Object?> get props => [instructorId];
}

class RefreshThesisEvent extends ThesisEvent {}

// States
abstract class ThesisState extends Equatable {
  const ThesisState();

  @override
  List<Object?> get props => [];
}

class ThesisInitialState extends ThesisState {}

class ThesisLoadingState extends ThesisState {}

class ThesisListLoadedState extends ThesisState {
  final List<ThesisModel> thesisList;

  const ThesisListLoadedState({required this.thesisList});

  @override
  List<Object?> get props => [thesisList];
}

class ThesisDetailLoadedState extends ThesisState {
  final ThesisModel thesis;

  const ThesisDetailLoadedState({required this.thesis});

  @override
  List<Object?> get props => [thesis];
}

class ThesisSearchResultsState extends ThesisState {
  final List<ThesisModel> searchResults;
  final String query;

  const ThesisSearchResultsState({
    required this.searchResults,
    required this.query,
  });

  @override
  List<Object?> get props => [searchResults, query];
}

class ThesisErrorState extends ThesisState {
  final String error;

  const ThesisErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

// Bloc
class ThesisBloc extends Bloc<ThesisEvent, ThesisState> {
  final ThesisRepository thesisRepository;
  
  // Cache for thesis list
  List<ThesisModel>? _cachedThesisList;
  List<ThesisModel>? _cachedAvailableThesis;
  DateTime? _lastThesisUpdate;
  static const Duration _cacheTimeout = Duration(minutes: 10);

  ThesisBloc({required this.thesisRepository}) : super(ThesisInitialState()) {
    on<GetAllThesisEvent>(_onGetAllThesis);
    on<GetAvailableThesisEvent>(_onGetAvailableThesis);
    on<GetThesisByIdEvent>(_onGetThesisById);
    on<SearchThesisEvent>(_onSearchThesis);
    on<GetThesisByInstructorEvent>(_onGetThesisByInstructor);
    on<RefreshThesisEvent>(_onRefreshThesis);
  }

  Future<void> _onGetAllThesis(GetAllThesisEvent event, Emitter<ThesisState> emit) async {
    try {
      // Check cache first
      if (_cachedThesisList != null && 
          _lastThesisUpdate != null && 
          DateTime.now().difference(_lastThesisUpdate!) < _cacheTimeout) {
        emit(ThesisListLoadedState(thesisList: _cachedThesisList!));
        return;
      }

      emit(ThesisLoadingState());
      final thesisList = await thesisRepository.getAllThesis();
      
      // Update cache
      _cachedThesisList = thesisList;
      _lastThesisUpdate = DateTime.now();
      
      emit(ThesisListLoadedState(thesisList: thesisList));
    } catch (e) {
      emit(ThesisErrorState(error: e.toString()));
    }
  }

  Future<void> _onGetAvailableThesis(GetAvailableThesisEvent event, Emitter<ThesisState> emit) async {
    try {
      // Check cache first
      if (_cachedAvailableThesis != null && 
          _lastThesisUpdate != null && 
          DateTime.now().difference(_lastThesisUpdate!) < _cacheTimeout) {
        emit(ThesisListLoadedState(thesisList: _cachedAvailableThesis!));
        return;
      }

      emit(ThesisLoadingState());
      final availableThesis = await thesisRepository.getAvailableThesis();
      
      // Update cache
      _cachedAvailableThesis = availableThesis;
      _lastThesisUpdate = DateTime.now();
      
      emit(ThesisListLoadedState(thesisList: availableThesis));
    } catch (e) {
      emit(ThesisErrorState(error: e.toString()));
    }
  }

  Future<void> _onGetThesisById(GetThesisByIdEvent event, Emitter<ThesisState> emit) async {
    try {
      emit(ThesisLoadingState());
      final thesis = await thesisRepository.getThesisById(event.thesisId);
      emit(ThesisDetailLoadedState(thesis: thesis));
    } catch (e) {
      emit(ThesisErrorState(error: e.toString()));
    }
  }

  Future<void> _onSearchThesis(SearchThesisEvent event, Emitter<ThesisState> emit) async {
    try {
      emit(ThesisLoadingState());
      final searchResults = await thesisRepository.searchThesis(event.query);
      emit(ThesisSearchResultsState(
        searchResults: searchResults,
        query: event.query,
      ));
    } catch (e) {
      emit(ThesisErrorState(error: e.toString()));
    }
  }

  Future<void> _onGetThesisByInstructor(GetThesisByInstructorEvent event, Emitter<ThesisState> emit) async {
    try {
      emit(ThesisLoadingState());
      final thesisList = await thesisRepository.getThesisByInstructor(event.instructorId);
      emit(ThesisListLoadedState(thesisList: thesisList));
    } catch (e) {
      emit(ThesisErrorState(error: e.toString()));
    }
  }

  Future<void> _onRefreshThesis(RefreshThesisEvent event, Emitter<ThesisState> emit) async {
    // Clear cache and reload
    _cachedThesisList = null;
    _cachedAvailableThesis = null;
    _lastThesisUpdate = null;
    add(GetAvailableThesisEvent());
  }
}
