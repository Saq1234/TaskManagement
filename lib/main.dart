import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_event.dart';
import 'bloc/task_state.dart';
import 'model/task_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task BLoC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => TaskBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _filter = 'all';
  bool _isButtonDisabled = true;

  void _addTask(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final task = Task(id: DateTime.now().toString(), title: text);
      context.read<TaskBloc>().add(AddTask(task));
      _controller.clear();
      _updateButtonState();
    }
  }

  void _markAllCompleted(BuildContext context) {
    final tasks = context.read<TaskBloc>().state.allTasks;
    for (var task in tasks) {
      if (!task.isCompleted) {
        context
            .read<TaskBloc>()
            .add(UpdateTask(task.copyWith(isCompleted: true)));
      }
    }
  }

  void _deleteAllCompleted(BuildContext context) {
    final tasks = context.read<TaskBloc>().state.allTasks;
    for (var task in tasks) {
      if (task.isCompleted) {
        context.read<TaskBloc>().add(DeleteTask(task));
      }
    }
  }

  void _updateButtonState() {
    setState(() {
      _isButtonDisabled = _controller.text.trim().isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateButtonState);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Manage Task'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
              context.read<TaskBloc>().add(FilterTasks(value));
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('All')),
              PopupMenuItem(value: 'completed', child: Text('Completed')),
              PopupMenuItem(value: 'pending', child: Text('Pending')),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10, right: 10),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'New Task',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add, color: Colors.blue),
                  onPressed: () => _addTask(context),
                  disabledColor: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state.filteredTasks.isEmpty) {
                    return Center(child: Image.asset("image/events.png"));
                  }
                  return ListView.builder(
                    itemCount: state.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = state.filteredTasks[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(task.title),
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) {
                              context.read<TaskBloc>().add(UpdateTask(
                                  task.copyWith(isCompleted: value)));
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<TaskBloc>().add(DeleteTask(task));
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _addTask(context),
                  child: Text('Add Task'),
                ),
                ElevatedButton(
                  onPressed: () => _markAllCompleted(context),
                  child: Text('All Completed'),
                ),
                ElevatedButton(
                  onPressed: () => _deleteAllCompleted(context),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
