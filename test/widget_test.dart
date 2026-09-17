import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/tasks/task_api.dart';
import 'package:flutter_task_app/features/tasks/task_list_page.dart';
import 'package:flutter_task_app/features/tasks/task_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TaskListPage shows empty state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TaskListPage(repository: _FakeTasks()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('No tasks yet. Add one above.'), findsOneWidget);
  });
}

class _FakeTasks implements TaskRepository {
  @override
  Future<Task> completeTask(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Task> createTask(String title) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> listTasks() async => [];
}
