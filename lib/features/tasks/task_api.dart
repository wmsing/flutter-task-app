import 'dart:convert';

import 'package:flutter_task_app/core/api_client.dart';
import 'package:flutter_task_app/features/tasks/task_model.dart';

abstract class TaskRepository {
  Future<List<Task>> listTasks();
  Future<Task> createTask(String title);
  Future<Task> completeTask(String id);
}

class TaskApi implements TaskRepository {
  TaskApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  @override
  Future<List<Task>> listTasks() async {
    final response = await _client.get('/tasks');
    if (response.statusCode != 200) {
      throw ApiException(ApiClient.errorMessage(response), statusCode: response.statusCode);
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw ApiException('Unexpected response shape');
    }
    return decoded
        .cast<Map<String, dynamic>>()
        .map(Task.fromJson)
        .toList(growable: false);
  }

  @override
  Future<Task> createTask(String title) async {
    final response = await _client.post('/tasks', body: {'title': title});
    if (response.statusCode != 201) {
      throw ApiException(ApiClient.errorMessage(response), statusCode: response.statusCode);
    }
    return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  @override
  Future<Task> completeTask(String id) async {
    final response = await _client.patch('/tasks/$id/complete');
    if (response.statusCode != 200) {
      throw ApiException(ApiClient.errorMessage(response), statusCode: response.statusCode);
    }
    return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
