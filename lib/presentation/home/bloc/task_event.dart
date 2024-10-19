part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllTasks extends TaskEvent {}

class DailyTasks extends TaskEvent {}

class OverdueTasks extends TaskEvent {}

class UpdateTaskAtIndex extends TaskEvent {
  final TaskModel model;
  const UpdateTaskAtIndex(this.model);

  @override
  List<Object> get props => [model];
}

class ChangeTaskAtIndex extends TaskEvent {
  final String? id;
  final bool status;

  const ChangeTaskAtIndex(this.id, this.status);

  @override
  List<Object?> get props => [id, status];
}

class AddTask extends TaskEvent {
  final TaskModel model;
  const AddTask(this.model);

  @override
  List<Object> get props => [model];
}

class DeleteTaskAtIndex extends TaskEvent {
  final String id;
  const DeleteTaskAtIndex(this.id);

  @override
  List<Object> get props => [id];
}
