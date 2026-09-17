import 'package:flutter_task_app/features/tasks/task_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Task.fromJson parses API shape', () {
    final task = Task.fromJson({
      'id': 'task-1',
      'title': 'Demo',
      'completed': false,
      'created_at': '2026-01-15T10:00:00Z',
    });

    expect(task.id, 'task-1');
    expect(task.title, 'Demo');
    expect(task.completed, isFalse);
    expect(task.createdAt.toUtc(), DateTime.utc(2026, 1, 15, 10));
  });
}
