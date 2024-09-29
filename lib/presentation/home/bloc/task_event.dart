part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadAllTasks extends TaskEvent {}

class GetTaskAtIndex extends TaskEvent {
  final int index;
  const GetTaskAtIndex(this.index);

  @override
  List<Object> get props => [index];
}

class UpdateTaskAtIndex extends TaskEvent {
  final int index;
  final TaskModel model;
  const UpdateTaskAtIndex(this.index, this.model);

  @override
  List<Object> get props => [index, model];
}

class AddTask extends TaskEvent {
  final TaskModel model;
  const AddTask(this.model);

  @override
  List<Object> get props => [model];
}

class DeleteTaskAtIndex extends TaskEvent {
  final int index;
  const DeleteTaskAtIndex(this.index);
}
