import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/local_datasource.dart';
import '../../../data/models/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final LocalDatasource localDatasource;
  TaskBloc({required this.localDatasource}) : super(TaskInitial()) {
    on<AddTask>((event, emit) async {
      emit(TaskAddedLoading());
      try {
        await localDatasource.addTask(event.model);
        final List<TaskModel?> updatedTasks = [
          ...(state as TaskLoaded).tasks,
          event.model
        ];
        emit(TaskLoaded(updatedTasks));
        emit(TaskAddedSuccess(event.model));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<LoadAllTasks>(
      (event, emit) async {
        emit(TaskListLoading());
        try {
          final List<TaskModel?> tasks = await localDatasource.getAllTasks();
          emit(TaskLoaded(tasks));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );

    on<UpdateTaskAtIndex>(
      (event, emit) async {
        emit(TaskUpdatedLoading());
        try {
          await localDatasource.updateTaskAtIndex(event.index, event.model);

          final List<TaskModel?> tasks = (state as TaskLoaded).tasks.map((e) {
            return e?.title == event.model.title ? event.model : e;
          }).toList();

          emit(TaskLoaded(tasks));
          emit(TaskUpdatedSuccess(event.model));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );

    on<DeleteTaskAtIndex>(
      (event, emit) async {
        emit(TaskADeletedLoading());
        try {
          await localDatasource.deleteTaskAtIndex(event.index);

          final updatedTasks = (state as TaskLoaded)
              .tasks
              .asMap() // Menggunakan asMap untuk mendapatkan indeks dan nilai
              .entries
              .where((entry) =>
                  entry.key !=
                  event
                      .index) // Hanya ambil entri yang bukan pada indeks yang dihapus
              .map(
                  (entry) => entry.value) // Ambil nilai dari entri yang tersisa
              .toList();
          emit(TaskLoaded(updatedTasks));
          emit(TaskDeletedSuccess());
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );
  }
}
