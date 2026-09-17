import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/tasks/task_api.dart';
import 'package:flutter_task_app/features/tasks/task_model.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key, TaskRepository? repository})
      : _repository = repository;

  final TaskRepository? _repository;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late final TaskRepository _repo = widget._repository ?? TaskApi();
  final _titleController = TextEditingController();

  List<Task> _tasks = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final tasks = await _repo.listTasks();
      if (!mounted) return;
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _addTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showMessage('Title is required');
      return;
    }
    try {
      final task = await _repo.createTask(title);
      if (!mounted) return;
      setState(() {
        _tasks = [..._tasks, task];
        _titleController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      _showMessage(e.toString());
    }
  }

  Future<void> _completeTask(Task task) async {
    if (task.completed) return;
    try {
      final updated = await _repo.completeTask(task.id);
      if (!mounted) return;
      setState(() {
        _tasks = [
          for (final t in _tasks) if (t.id == updated.id) updated else t,
        ];
      });
    } catch (e) {
      if (!mounted) return;
      _showMessage(e.toString());
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(onPressed: _loadTasks, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'New task',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(onPressed: _addTask, child: const Text('Add')),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _loadTasks, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    if (_tasks.isEmpty) {
      return const Center(child: Text('No tasks yet. Add one above.'));
    }
    return ListView.separated(
      itemCount: _tasks.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return ListTile(
          leading: Icon(
            task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: task.completed ? Colors.green : null,
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.completed ? TextDecoration.lineThrough : null,
            ),
          ),
          onTap: task.completed ? null : () => _completeTask(task),
        );
      },
    );
  }
}
