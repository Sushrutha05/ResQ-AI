class ParsedTask {
  final String title;
  final DateTime? deadline;
  final String priority;
  final int estimatedDuration; // in minutes

  ParsedTask({
    required this.title,
    this.deadline,
    required this.priority,
    required this.estimatedDuration,
  });

  factory ParsedTask.fromJson(Map<String, dynamic> json) {
    return ParsedTask(
      title: json['title'] as String? ?? 'Untitled Task',
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'])
          : null,
      priority: json['priority'] as String? ?? 'Medium',
      estimatedDuration: json['estimatedDuration'] as int? ?? 0,
    );
  }
}

class ParsedSubtask {
  final String title;
  final int estimatedDuration; // in minutes

  ParsedSubtask({
    required this.title,
    required this.estimatedDuration,
  });

  factory ParsedSubtask.fromJson(Map<String, dynamic> json) {
    return ParsedSubtask(
      title: json['title'] as String? ?? 'Untitled Subtask',
      estimatedDuration: json['estimatedDuration'] as int? ?? 0,
    );
  }
}
