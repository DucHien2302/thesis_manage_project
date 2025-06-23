import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/models/batch_models.dart';
import 'package:thesis_manage_project/services/batch_major_service.dart';

part 'batch_major_event.dart';
part 'batch_major_state.dart';

class BatchMajorBloc extends Bloc<BatchMajorEvent, BatchMajorState> {
  final BatchMajorService _service;

  BatchMajorBloc({required BatchMajorService service})
      : _service = service,
        super(BatchMajorInitial()) {
    on<LoadBatchesAndMajors>(_onLoadBatchesAndMajors);
  }  Future<void> _onLoadBatchesAndMajors(
    LoadBatchesAndMajors event,
    Emitter<BatchMajorState> emit,
  ) async {
    emit(BatchMajorLoading());
    try {
      final batches = await _service.getBatches();
      final majors = await _service.getMajors();
      final departments = await _service.getDepartments();
      final lecturers = await _service.getLecturers();
      emit(BatchMajorLoaded(
        batches: batches, 
        majors: majors,
        departments: departments,
        lecturers: lecturers,
      ));
    } catch (e) {
      emit(BatchMajorError(message: e.toString()));
    }
  }
}
