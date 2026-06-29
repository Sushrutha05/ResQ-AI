import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resq_ai/ai/coach/coach_models.dart';
import 'package:resq_ai/ai/coach/coach_provider.dart';
import 'package:resq_ai/features/tasks/presentation/providers/task_providers.dart';
import 'package:resq_ai/features/profile/presentation/providers/settings_provider.dart';

class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key});

  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  bool _isLoading = false;
  DailyBriefing? _briefing;

  @override
  void initState() {
    super.initState();
    // Delay fetching slightly to allow UI to build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBriefing();
    });
  }

  Future<void> _fetchBriefing() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = ref.read(userTasksStreamProvider).value ?? [];
      final coachAgent = ref.read(coachAgentProvider);
      final isStrict = ref.read(coachStrictnessProvider);
      final briefing = await coachAgent.generateDailyBriefing(tasks, isStrict: isStrict);

      if (mounted) {
        setState(() {
          _briefing = briefing;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load coach briefing: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Coach'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchBriefing,
          ),
        ],
      ),
      body: SafeArea(
        child:
            _isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Coach is analyzing your workload...',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
                : _briefing == null
                ? Center(
                  child: ElevatedButton(
                    onPressed: _fetchBriefing,
                    child: const Text('Get Daily Briefing'),
                  ),
                )
                : _buildBriefingView(context, _briefing!),
      ),
    );
  }

  Widget _buildBriefingView(BuildContext context, DailyBriefing briefing) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.psychology,
                  size: 36,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  briefing.greeting,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'The Breakdown',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            briefing.motivationText,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 4,
            shadowColor: theme.colorScheme.primary.withAlpha(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: theme.colorScheme.primary.withAlpha(80),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flag, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'Top Priority Right Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    briefing.topRecommendation,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 32),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: theme.colorScheme.onSecondaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            briefing.impactStatement,
                            style: TextStyle(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
