import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'coach_agent.dart';

final coachAgentProvider = Provider<CoachAgent>((ref) {
  return CoachAgent();
});
