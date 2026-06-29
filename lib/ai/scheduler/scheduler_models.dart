class ScheduleBlock {
  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String type; // 'task', 'break', or 'event'
  final String? taskId;

  ScheduleBlock({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.type,
    this.taskId,
  });

  factory ScheduleBlock.fromJson(Map<String, dynamic> json) {
    return ScheduleBlock(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      title: json['title'] as String,
      type: json['type'] as String,
      taskId: json['taskId'] as String?,
    );
  }
}
