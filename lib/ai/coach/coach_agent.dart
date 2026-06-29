import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../features/tasks/domain/entities/task_entity.dart';
import 'coach_models.dart';

class CoachAgent {
  late final GenerativeModel _model;

  CoachAgent() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in .env');
    }
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
  }

  Future<DailyBriefing> generateDailyBriefing(List<TaskEntity> tasks) async {
    final pendingTasks = tasks.where((t) => t.status != 'Completed').toList();
    final highRiskTasks =
        pendingTasks.where((t) => (t.riskScore ?? 0) > 40).toList();

    String taskContext = "Current Tasks:\n";
    if (pendingTasks.isEmpty) {
      taskContext += "The user has no pending tasks!\n";
    } else {
      if (highRiskTasks.isNotEmpty) {
        taskContext += "CRITICAL ATTENTION NEEDED for these High Risk tasks:\n";
        for (var task in highRiskTasks) {
          taskContext += "- ${task.title} (Risk: ${task.riskScore ?? 0}%)\n";
        }
        taskContext += "\nOther Tasks:\n";
      }
      for (var task in pendingTasks.where((t) => (t.riskScore ?? 0) <= 40)) {
        taskContext +=
            "- ${task.title} (Deadline: ${task.deadline}, Risk: ${task.riskScore ?? 0}%)\n";
      }
    }

    final schema = Schema.object(
      properties: {
        'greeting': Schema.string(
          description: 'A punchy, energetic, and short greeting.',
        ),
        'motivationText': Schema.string(
          description:
              'A short paragraph acknowledging their workload and motivating them. Act as a strict but encouraging accountability partner.',
        ),
        'topRecommendation': Schema.string(
          description:
              'The single most important thing they should do right now.',
        ),
        'impactStatement': Schema.string(
          description:
              'A data-driven or logical statement on how starting now improves their success chance (e.g. "If you begin now, your completion chance increases from 52% to 91%").',
        ),
      },
      requiredProperties: [
        'greeting',
        'motivationText',
        'topRecommendation',
        'impactStatement',
      ],
    );

    final prompt = '''
You are the "ResQ AI Coach", an intelligent, no-nonsense accountability partner.
Your goal is to give the user a quick daily briefing. Look at their tasks and high-risk tasks.
Don't be overly polite. Be direct, motivating, and focus on action.

$taskContext
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
      return DailyBriefing.fromJson(jsonMap);
    } catch (e) {
      print('Error generating coach briefing: $e');
      return DailyBriefing(
        greeting: 'Hello there.',
        motivationText: 'Could not connect to the Coach AI at this moment.',
        topRecommendation: 'Review your tasks manually.',
        impactStatement: 'Consistency is key.',
      );
    }
  }
}
