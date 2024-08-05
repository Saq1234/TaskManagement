import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:task/bloc/task_event.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_state.dart';
import '../model/task_model.dart';

void main() {
  group('TaskBloc', () {
    late TaskBloc taskBloc;

    setUp(() {
      taskBloc = TaskBloc();
    });

    tearDown(() {
      taskBloc.close();
    });

    blocTest<TaskBloc, TaskState>(
      'emits [] when nothing is added',
      build: () => taskBloc,
      expect: () => [],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskState] with added task when AddTask event is added',
      build: () => taskBloc,
      act: (bloc) => bloc.add(AddTask(Task(id: '1', title: 'Test Task'))),
      expect: () => [
        TaskState(
            allTasks: [Task(id: '1', title: 'Test Task')],
            filteredTasks: [Task(id: '1', title: 'Test Task')]),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskState] with updated task when UpdateTask event is added',
      build: () => taskBloc,
      act: (bloc) {
        bloc.add(AddTask(Task(id: '1', title: 'Test Task')));
        bloc.add(
            UpdateTask(Task(id: '1', title: 'Test Task', isCompleted: true)));
      },
      expect: () => [
        TaskState(
            allTasks: [Task(id: '1', title: 'Test Task')],
            filteredTasks: [Task(id: '1', title: 'Test Task')]),
        TaskState(allTasks: [
          Task(id: '1', title: 'Test Task', isCompleted: true)
        ], filteredTasks: [
          Task(id: '1', title: 'Test Task', isCompleted: true)
        ]),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskState] with deleted task when DeleteTask event is added',
      build: () => taskBloc,
      act: (bloc) {
        bloc.add(AddTask(Task(id: '1', title: 'Test Task')));
        bloc.add(DeleteTask(Task(id: '1', title: 'Test Task')));
      },
      expect: () => [
        TaskState(
            allTasks: [Task(id: '1', title: 'Test Task')],
            filteredTasks: [Task(id: '1', title: 'Test Task')]),
        TaskState(allTasks: [], filteredTasks: []),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskState] with filtered tasks when FilterTasks event is added',
      build: () => taskBloc,
      act: (bloc) {
        bloc.add(AddTask(Task(id: '1', title: 'Test Task')));
        bloc.add(
            AddTask(Task(id: '2', title: 'Test Task 2', isCompleted: true)));
        bloc.add(FilterTasks('completed'));
      },
      expect: () => [
        TaskState(
            allTasks: [Task(id: '1', title: 'Test Task')],
            filteredTasks: [Task(id: '1', title: 'Test Task')]),
        TaskState(allTasks: [
          Task(id: '1', title: 'Test Task'),
          Task(id: '2', title: 'Test Task 2', isCompleted: true)
        ], filteredTasks: [
          Task(id: '1', title: 'Test Task'),
          Task(id: '2', title: 'Test Task 2', isCompleted: true)
        ]),
        TaskState(allTasks: [
          Task(id: '1', title: 'Test Task'),
          Task(id: '2', title: 'Test Task 2', isCompleted: true)
        ], filteredTasks: [
          Task(id: '2', title: 'Test Task 2', isCompleted: true)
        ]),
      ],
    );
  });
}
