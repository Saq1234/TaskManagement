import 'package:bloc/bloc.dart';
import '../model/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState(allTasks: [], filteredTasks: [])) {
    on<AddTask>((event, emit) {
      final updatedTasks = List<Task>.from(state.allTasks)..add(event.task);
      emit(state.copyWith(allTasks: updatedTasks, filteredTasks: updatedTasks));
    });

    on<UpdateTask>((event, emit) {
      final updatedTasks = state.allTasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      emit(state.copyWith(allTasks: updatedTasks, filteredTasks: updatedTasks));
    });

    on<DeleteTask>((event, emit) {
      final updatedTasks =
          state.allTasks.where((task) => task.id != event.task.id).toList();
      emit(state.copyWith(allTasks: updatedTasks, filteredTasks: updatedTasks));
    });

    on<FilterTasks>((event, emit) {
      List<Task> filteredTasks;
      if (event.filter == 'all') {
        filteredTasks = state.allTasks;
      } else if (event.filter == 'completed') {
        filteredTasks =
            state.allTasks.where((task) => task.isCompleted).toList();
      } else {
        filteredTasks =
            state.allTasks.where((task) => !task.isCompleted).toList();
      }
      emit(state.copyWith(filteredTasks: filteredTasks));
    });
  }
}
