import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'scheduler_agent.dart';
import 'scheduler_models.dart';

final schedulerAgentProvider = Provider<SchedulerAgent>((ref) {
  return SchedulerAgent();
});

class GeneratedScheduleNotifier extends Notifier<List<ScheduleBlock>> {
  @override
  List<ScheduleBlock> build() => [];

  void updateSchedule(List<ScheduleBlock> newSchedule) {
    state = newSchedule;
  }
}

final generatedScheduleProvider = NotifierProvider<GeneratedScheduleNotifier, List<ScheduleBlock>>(() {
  return GeneratedScheduleNotifier();
});
