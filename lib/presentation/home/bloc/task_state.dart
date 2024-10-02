part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {}

final class TaskListLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel?> tasks;
  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskUpdatedSuccess extends TaskState {}

class TaskAddedSuccess extends TaskState {
  final TaskModel? model;

  const TaskAddedSuccess(
    this.model,
  );

  @override
  List<Object?> get props => [model];
}

class TaskDeletedSuccess extends TaskState {}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
