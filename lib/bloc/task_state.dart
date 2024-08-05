import 'package:equatable/equatable.dart';
import '../model/task_model.dart';

class TaskState extends Equatable {
  final List<Task> allTasks;
  final List<Task> filteredTasks;

  const TaskState({
    required this.allTasks,
    required this.filteredTasks,
  });

  TaskState copyWith({
    List<Task>? allTasks,
    List<Task>? filteredTasks,
  }) {
    return TaskState(
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
    );
  }

  @override
  List<Object?> get props => [allTasks, filteredTasks];
}
