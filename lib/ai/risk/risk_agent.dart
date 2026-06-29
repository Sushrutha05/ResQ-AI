import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'risk_models.dart';
import '../../features/tasks/domain/entities/task_entity.dart';

class RiskAgent {
  late GenerativeModel _model;

  RiskAgent() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env');
    }

    _model = GenerativeModel(model: 'gemini-3.1-flash-lite', apiKey: apiKey);
  }

  Future<RiskAssessment> assessTaskRisk(TaskEntity task) async {
    final schema = Schema.object(
      properties: {
        'score': Schema.integer(
          description: 'A risk score from 0 to 100. 100 is perfectly safe, 0 means almost impossible to complete in time.',
        ),
        'explanation': Schema.string(
          description: 'A very concise 1-sentence explanation of why this risk score was given.',
        ),
      },
      requiredProperties: ['score', 'explanation'],
    );

    final now = DateTime.now();
    final remainingMinutes = task.deadline.difference(now).inMinutes;

    final prompt = '''
Assess the completion probability (survival score) of this task.
Current Time: ${now.toIso8601String()}
Task Title: ${task.title}
Priority: ${task.priority}
Estimated Duration Needed: ${task.estimatedDuration} minutes
Deadline: ${task.deadline.toIso8601String()} (Time left: $remainingMinutes minutes)
Subtasks Count: ${task.subtasks.length}

Evaluate the feasibility. If the time left is less than the estimated duration, the score should be very low (close to 0). If there is plenty of time, the score should be high (near 100). Provide a 1-sentence explanation.
''';

    try {
      final response = await _model.generateContent(
        [Content.text(prompt)],
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: schema,
        ),
      );

      if (response.text == null) {
        throw Exception('No response from AI');
      }

      final jsonMap = jsonDecode(response.text!);
      return RiskAssessment.fromJson(jsonMap);
    } catch (e) {
      print('Error assessing risk: $e');
      rethrow;
    }
  }
}
