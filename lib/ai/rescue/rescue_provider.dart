import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:resq_ai/features/tasks/domain/entities/task_entity.dart';
import 'rescue_agent.dart';

final rescueAgentProvider = Provider<RescueAgent>((ref) {
  return RescueAgent();
});

final isRescueModeActiveProvider = StateProvider<bool>((ref) => false);
final rescueUndoStateProvider = StateProvider<List<TaskEntity>>((ref) => []);
