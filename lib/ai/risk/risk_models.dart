class RiskAssessment {
  final int score;
  final String explanation;

  RiskAssessment({
    required this.score,
    required this.explanation,
  });

  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    return RiskAssessment(
      score: json['score'] as int? ?? 100,
      explanation: json['explanation'] as String? ?? 'No explanation provided.',
    );
  }
}
