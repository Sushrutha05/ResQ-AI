class DailyBriefing {
  final String greeting;
  final String motivationText;
  final String topRecommendation;
  final String impactStatement;

  DailyBriefing({
    required this.greeting,
    required this.motivationText,
    required this.topRecommendation,
    required this.impactStatement,
  });

  factory DailyBriefing.fromJson(Map<String, dynamic> json) {
    return DailyBriefing(
      greeting: json['greeting'] ?? 'Hello!',
      motivationText: json['motivationText'] ?? 'Ready to get started?',
      topRecommendation: json['topRecommendation'] ?? 'Review your tasks.',
      impactStatement: json['impactStatement'] ?? 'Every little bit counts.',
    );
  }
}
