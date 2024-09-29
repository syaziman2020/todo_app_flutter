part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {}

final class TaskListLoading extends TaskState {}

final class TaskAtIndexLoading extends TaskState {}

final class TaskAddedLoading extends TaskState {}

final class TaskUpdatedLoading extends TaskState {}

final class TaskADeletedLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel?> tasks;
  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskIndexLoaded extends TaskState {
  final TaskModel? model;
  const TaskIndexLoaded(this.model);

  @override
  List<Object?> get props => [model];
}

class TaskUpdatedSuccess extends TaskState {
  final TaskModel? model;
  const TaskUpdatedSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class TaskAddedSuccess extends TaskState {
  final TaskModel? model;
  const TaskAddedSuccess(this.model);

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
