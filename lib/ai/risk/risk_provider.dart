import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'risk_agent.dart';

final riskAgentProvider = Provider<RiskAgent>((ref) {
  return RiskAgent();
});
