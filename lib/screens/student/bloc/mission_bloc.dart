import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/models/mission_models.dart';
import 'package:thesis_manage_project/repositories/mission_repository.dart';

// Events
abstract class MissionEvent extends Equatable {
  const MissionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksForThesis extends MissionEvent {
  final String thesisId;

  const LoadTasksForThesis({required this.thesisId});

  @override
  List<Object?> get props => [thesisId];
}

class LoadMissionDetails extends MissionEvent {
  final String missionId;

  const LoadMissionDetails({required this.missionId});

  @override
  List<Object?> get props => [missionId];
}

class UpdateTaskStatus extends MissionEvent {
  final String taskId;
  final int newStatus;

  const UpdateTaskStatus({required this.taskId, required this.newStatus});

  @override
  List<Object?> get props => [taskId, newStatus];
}

// States
abstract class MissionState extends Equatable {
  const MissionState();

  @override
  List<Object?> get props => [];
}

class MissionInitial extends MissionState {}

class MissionLoading extends MissionState {}

class TasksLoaded extends MissionState {
  final List<Task> tasks;
  final String thesisId;

  const TasksLoaded({required this.tasks, required this.thesisId});

  @override
  List<Object?> get props => [tasks, thesisId];
}

class MissionWithTasksLoaded extends MissionState {
  final Mission mission;

  const MissionWithTasksLoaded({required this.mission});

  @override
  List<Object?> get props => [mission];
}

class TaskUpdated extends MissionState {
  final Task task;

  const TaskUpdated({required this.task});

  @override
  List<Object?> get props => [task];
}

class MissionError extends MissionState {
  final String message;

  const MissionError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class MissionBloc extends Bloc<MissionEvent, MissionState> {
  final MissionRepository _missionRepository;

  MissionBloc({required MissionRepository missionRepository}) 
    : _missionRepository = missionRepository,
      super(MissionInitial()) {
    on<LoadTasksForThesis>(_onLoadTasksForThesis);
    on<LoadMissionDetails>(_onLoadMissionDetails);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
  }
  Future<void> _onLoadTasksForThesis(
    LoadTasksForThesis event,
    Emitter<MissionState> emit,
  ) async {
    try {
      emit(MissionLoading());
      final tasks = await _missionRepository.getTasksForThesis(event.thesisId);
      emit(TasksLoaded(tasks: tasks, thesisId: event.thesisId));
    } catch (e) {
      emit(MissionError(message: e.toString()));
    }
  }

  Future<void> _onLoadMissionDetails(
    LoadMissionDetails event,
    Emitter<MissionState> emit,
  ) async {
    try {
      emit(MissionLoading());
      final mission = await _missionRepository.getMissionWithTasks(event.missionId);
      emit(MissionWithTasksLoaded(mission: mission));
    } catch (e) {
      emit(MissionError(message: e.toString()));
    }
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatus event,
    Emitter<MissionState> emit,
  ) async {
    try {
      // Keep the current state loaded while updating
      final currentState = state;
      emit(MissionLoading());
      
      // Update the task
      final updatedTask = await _missionRepository.updateTaskStatus(
        event.taskId, 
        event.newStatus
      );
      
      // First emit the updated task
      emit(TaskUpdated(task: updatedTask));
        // Then fetch and emit the updated list or mission if needed
      if (currentState is TasksLoaded) {
        // If we were viewing a list of tasks, refresh that list using the original thesisId
        final tasks = await _missionRepository.getTasksForThesis(currentState.thesisId);
        emit(TasksLoaded(tasks: tasks, thesisId: currentState.thesisId));
      } else if (currentState is MissionWithTasksLoaded) {
        // If we were viewing a mission with tasks, refresh that mission
        final mission = await _missionRepository.getMissionWithTasks(
          currentState.mission.id
        );
        emit(MissionWithTasksLoaded(mission: mission));
      }
    } catch (e) {
      emit(MissionError(message: e.toString()));
    }
  }
}
