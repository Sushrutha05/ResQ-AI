import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'planner_models.dart';
import '../../features/tasks/domain/entities/task_entity.dart';

class PlannerAgent {
  late GenerativeModel _model;

  PlannerAgent() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env');
    }

    _model = GenerativeModel(model: 'gemini-3.1-flash-lite', apiKey: apiKey);
  }

  Future<List<ParsedTask>> parseNaturalLanguageTask(String input) async {
    final schema = Schema.array(
      description: 'A list of tasks extracted from the input.',
      items: Schema.object(
      properties: {
        'title': Schema.string(description: 'A concise title for the task.'),
        'deadline': Schema.string(
          description:
              'ISO 8601 formatted datetime if a deadline is mentioned. E.g., 2026-06-30T17:00:00Z. Leave null if none.',
        ),
        'priority': Schema.string(
          description:
              'One of: Low, Medium, High. Infer from urgency in the text.',
        ),
        'estimatedDuration': Schema.integer(
          description:
              'Estimated duration in minutes based on the task description.',
        ),
      },
      requiredProperties: ['title', 'priority', 'estimatedDuration'],
      ),
    );

    final prompt =
        'Parse the following natural language task input into a structured format of one or more tasks. Current time is ${DateTime.now().toIso8601String()}.\n\nInput: "$input"';

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

      final List<dynamic> jsonList = jsonDecode(response.text!);
      return jsonList.map((e) => ParsedTask.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error parsing task: $e');
      rethrow;
    }
  }

  Future<List<ParsedSubtask>> generateSubtasks(TaskEntity task) async {
    final schema = Schema.array(
      description: 'A list of sequential subtasks.',
      items: Schema.object(
        properties: {
          'title': Schema.string(description: 'Title of the subtask.'),
          'estimatedDuration': Schema.integer(
            description: 'Estimated duration in minutes for this subtask.',
          ),
        },
        requiredProperties: ['title', 'estimatedDuration'],
      ),
    );

    final prompt =
        'Break down the following task into manageable, sequential subtasks.\n'
        'Task Title: ${task.title}\n'
        'Description: ${task.description}\n'
        'Ensure the total duration of subtasks roughly aligns with the task scope.';

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

      final List<dynamic> jsonList = jsonDecode(response.text!);
      return jsonList
          .map((e) => ParsedSubtask.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error generating subtasks: $e');
      rethrow;
    }
  }
}
