class RecoveryPlan {
  final String emergencyAdvice;
  final List<String> dropTaskIds;
  final List<String> dropReasons;
  final List<String> keepTaskIds;

  RecoveryPlan({
    required this.emergencyAdvice,
    required this.dropTaskIds,
    required this.dropReasons,
    required this.keepTaskIds,
  });

  factory RecoveryPlan.fromJson(Map<String, dynamic> json) {
    return RecoveryPlan(
      emergencyAdvice: json['emergencyAdvice'] ?? 'Try to focus on the absolute essentials right now.',
      dropTaskIds: List<String>.from(json['dropTaskIds'] ?? []),
      dropReasons: List<String>.from(json['dropReasons'] ?? []),
      keepTaskIds: List<String>.from(json['keepTaskIds'] ?? []),
    );
  }
}
