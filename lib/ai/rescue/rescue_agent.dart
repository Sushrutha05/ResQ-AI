import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../features/tasks/domain/entities/task_entity.dart';
import 'rescue_models.dart';

class RescueAgent {
  late final GenerativeModel _model;

  RescueAgent() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in .env');
    }
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  Future<RecoveryPlan> generateRecoveryPlan(List<TaskEntity> tasks) async {
    final pendingTasks = tasks.where((t) => t.status != 'Completed').toList();
    if (pendingTasks.isEmpty) {
      return RecoveryPlan(
        emergencyAdvice: "You don't have any pending tasks right now. You're fine!",
        dropTaskIds: [],
        dropReasons: [],
        keepTaskIds: [],
      );
    }

    String taskContext = "Current Overwhelming Workload:\n";
    for (var task in pendingTasks) {
      taskContext += "- [ID: ${task.taskId}] ${task.title} (Priority: ${task.priority}, Deadline: ${task.deadline}, Risk: ${task.riskScore ?? 0}%, Est. Duration: ${task.estimatedDuration} mins)\n";
    }

    final schema = Schema.object(
      properties: {
        'emergencyAdvice': Schema.string(description: 'A 2-sentence blunt, empathetic advice on why they need to drop some tasks immediately to save their schedule.'),
        'dropTaskIds': Schema.array(items: Schema.string(), description: 'The IDs of the tasks that should be delayed or dropped (lowest priority, lowest risk, highest effort, furthest deadline).'),
        'dropReasons': Schema.array(items: Schema.string(), description: 'A short reason for each dropped task explaining WHY it must be delayed.'),
        'keepTaskIds': Schema.array(items: Schema.string(), description: 'The IDs of the tasks that MUST be kept because they are too high value, high priority, or high risk.'),
      },
      requiredProperties: ['emergencyAdvice', 'dropTaskIds', 'dropReasons', 'keepTaskIds'],
    );

    final prompt = '''
You are the "ResQ AI Rescue Agent". The user's schedule has catastrophically failed. Their success score is critical.
Your job is to TRIAGE.
Analyze the tasks and brutally decide which ones MUST be dropped or delayed to tomorrow to save the most critical, high-value tasks today.
CRITICAL RULE: You MUST prioritize keeping high-value tasks (High Priority, High Risk, near deadlines) active.
You MUST drop or delay the lower-value tasks (Low Priority, Low Risk, easily postponable) to free up time.
Select 1 or more tasks to drop (depending on how overloaded they are), and list the ones to keep.

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
      return RecoveryPlan.fromJson(jsonMap);
    } catch (e) {
      return RecoveryPlan(
        emergencyAdvice: 'Failed to generate a recovery plan due to an AI error.',
        dropTaskIds: [],
        dropReasons: [],
        keepTaskIds: [],
      );
    }
  }
}
