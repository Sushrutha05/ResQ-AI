import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'scheduler_models.dart';
import '../../features/tasks/domain/entities/task_entity.dart';
import '../../features/calendar/domain/entities/calendar_event.dart';

class SchedulerAgent {
  late GenerativeModel _model;

  SchedulerAgent() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env');
    }

    _model = GenerativeModel(model: 'gemini-3.1-flash-lite', apiKey: apiKey);
  }

  Future<List<ScheduleBlock>> generateSchedule(List<TaskEntity> tasks, List<CalendarEvent> events) async {
    final schema = Schema.array(
      description: 'A timeline of schedule blocks for the day.',
      items: Schema.object(
        properties: {
          'startTime': Schema.string(
            description: 'ISO 8601 formatted datetime for the start of the block.',
          ),
          'endTime': Schema.string(
            description: 'ISO 8601 formatted datetime for the end of the block.',
          ),
          'title': Schema.string(
            description: 'Title of the task, break, or calendar event.',
          ),
          'type': Schema.string(
            description: 'Either "task", "break", or "event".',
          ),
          'taskId': Schema.string(
            description: 'The taskId if this is a task, or the eventId if this is an event, or empty for breaks.',
          ),
        },
        requiredProperties: ['startTime', 'endTime', 'title', 'type'],
      ),
    );

    final now = DateTime.now();
    // Assuming the user's day ends in about 8-12 hours from 'now', or just planning for the rest of today.
    final eod = DateTime(now.year, now.month, now.day, 22, 0); // 10 PM

    final tasksJson = tasks.map((t) => {
      'id': t.taskId,
      'title': t.title,
      'priority': t.priority,
      'estimatedDuration': t.estimatedDuration,
      'deadline': t.deadline.toIso8601String(),
    }).toList();

    final eventsJson = events.map((e) => {
      'id': e.eventId,
      'title': e.title,
      'startTime': e.startTime.toIso8601String(),
      'endTime': e.endTime.toIso8601String(),
      'isAllDay': e.isAllDay,
    }).toList();

    final prompt = '''
You are an expert AI Scheduler.
Current Time: ${now.toIso8601String()}
End of Work Day: ${eod.toIso8601String()}

Please generate a realistic schedule for the remainder of the day.

HARD CONSTRAINTS (Google Calendar Events):
You MUST include these existing calendar events in the final timeline exactly at their specified times. The type for these MUST be "event".
${jsonEncode(eventsJson)}

TASKS TO SCHEDULE:
Schedule as many of these tasks as possible around the calendar events above. Their type MUST be "task".
${jsonEncode(tasksJson)}

Rules:
1. Schedule high priority and close-deadline tasks first.
2. Add short 5-15 minute breaks between long tasks.
3. If tasks take more time than available today, schedule the most critical ones today and ignore the rest.
4. Ensure `startTime` and `endTime` are consecutive and do NOT overlap with each other or with Calendar Events.
5. You MUST wrap around existing calendar events. Do NOT schedule a task during an event.
6. The `taskId` must perfectly match the provided task id or event id.
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

      final List<dynamic> jsonList = jsonDecode(response.text!);
      return jsonList.map((e) => ScheduleBlock.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error generating schedule: $e');
      rethrow;
    }
  }
}
