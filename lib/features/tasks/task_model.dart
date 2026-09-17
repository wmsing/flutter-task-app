class Task {
  const Task({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
  });

  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
