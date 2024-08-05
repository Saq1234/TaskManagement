import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/task_bloc.dart';

import '../main.dart';

void main() {
  testWidgets('Add, update, delete tasks and filter tasks',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => TaskBloc(),
        child: MaterialApp(home: MyHomePage()),
      ),
    );

    // Initial state
    expect(find.text('No tasks available'), findsOneWidget);

    // Add task
    await tester.enterText(find.byType(TextField), 'Test Task');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Test Task'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);

    // Update task
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // Delete task
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('No tasks available'), findsOneWidget);

    // Add multiple tasks and filter
    await tester.enterText(find.byType(TextField), 'Task 1');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Task 2');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

    await tester.tap(find.text('Completed').last);
    await tester.pump();

    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 1'), findsNothing);
  });
}
