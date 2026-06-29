import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'planner_agent.dart';

final plannerAgentProvider = Provider<PlannerAgent>((ref) {
  return PlannerAgent();
});
