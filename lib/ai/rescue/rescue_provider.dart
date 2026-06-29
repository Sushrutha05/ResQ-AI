import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rescue_agent.dart';

final rescueAgentProvider = Provider<RescueAgent>((ref) {
  return RescueAgent();
});
