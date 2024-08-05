import 'package:equatable/equatable.dart';

import '../model/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final Task task;

  const DeleteTask(this.task);

  @override
  List<Object?> get props => [task];
}

class FilterTasks extends TaskEvent {
  final String filter;

  const FilterTasks(this.filter);

  @override
  List<Object?> get props => [filter];
}
