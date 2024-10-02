import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/local_datasource.dart';
import '../../../data/models/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final LocalDatasource localDatasource;
  TaskBloc({required this.localDatasource}) : super(TaskInitial()) {
    bool isToday(DateTime dateTime) {
      final now = DateTime.now();
      return dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day;
    }

    bool isPast(DateTime dateTime) {
      final now = DateTime.now();
      return dateTime.isBefore(
        DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
          now.second,
        ),
      );
    }

    on<AddTask>((event, emit) async {
      try {
        await localDatasource.addTask(event.model);
        final List<TaskModel?> updatedTasks =
            await localDatasource.getAllTasks();

        emit(TaskAddedSuccess(event.model));
        emit(TaskLoaded(updatedTasks));
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

    on<DailyTasks>(
      (event, emit) async {
        emit(TaskListLoading());
        try {
          final List<TaskModel?> tasks = await localDatasource.getAllTasks();
          final List<TaskModel?> filterDaily = tasks.where((task) {
            if (task?.dateTime != null && task?.status == false) {
              return isToday(
                  task!.dateTime!); // Cek apakah dateTime adalah hari ini
            }
            return false;
          }).toList();

          emit(TaskLoaded(filterDaily));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );
    on<OverdueTasks>(
      (event, emit) async {
        emit(TaskListLoading());
        try {
          final List<TaskModel?> tasks = await localDatasource.getAllTasks();
          final List<TaskModel?> filterOverdue = tasks.where((task) {
            if (task?.dateTime != null && task?.status == false) {
              return isPast(
                  task!.dateTime!); // Cek apakah dateTime adalah hari ini
            }
            return false;
          }).toList();

          emit(TaskLoaded(filterOverdue));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );

    on<UpdateTaskAtIndex>(
      (event, emit) async {
        try {
          await localDatasource.updateTaskAtIndex(event.id, event.model);

          final List<TaskModel?> tasks = await localDatasource.getAllTasks();
          emit(TaskUpdatedSuccess());
          emit(TaskLoaded(tasks));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );
    on<ChangeTaskAtIndex>(
      (event, emit) async {
        try {
          await localDatasource.updateTaskStatusAtIndex(event.id, event.status);

          List<TaskModel?> tasks = await localDatasource.getAllTasks();

          emit(TaskLoaded(tasks));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );

    on<DeleteTaskAtIndex>(
      (event, emit) async {
        try {
          await localDatasource.deleteTaskAtIndex(event.id);

          final updatedTasks = await localDatasource.getAllTasks();
          emit(TaskDeletedSuccess());
          emit(TaskLoaded(updatedTasks));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );
  }
}
