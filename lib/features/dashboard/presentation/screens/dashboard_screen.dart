import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:resq_ai/features/tasks/domain/entities/task_entity.dart';
import 'package:resq_ai/features/tasks/presentation/providers/task_providers.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import 'package:resq_ai/ai/scheduler/scheduler_provider.dart';
import 'package:resq_ai/ai/scheduler/scheduler_models.dart';
import '../widgets/rescue_bottom_sheet.dart';
import 'navigation_shell.dart';

final recommendationDismissedProvider = StateProvider<bool>((ref) => false);
final isRescueModeActiveProvider = StateProvider<bool>((ref) => false);
final rescueUndoStateProvider = StateProvider<List<TaskEntity>>((ref) => []);

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userEmail = authState.value?.email ?? 'Developer';
    final displayName = userEmail.split('@')[0];
    final theme = Theme.of(context);

    final tasksAsync = ref.watch(userTasksStreamProvider);
    final tasks = tasksAsync.value ?? [];
    final schedule = ref.watch(generatedScheduleProvider);
    final isDismissed = ref.watch(recommendationDismissedProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'ResQ AI',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8),
        ),
        actions: [
          IconButton(
            tooltip: 'Log Out',
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Welcome Greeting
              Text(
                '${_getGreeting()}, ${displayName[0].toUpperCase()}${displayName.substring(1)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Here is your intelligent schedule overview for today.',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              // RESCUE BANNER (If score < 40% or if Rescue Mode is Active)
              if (_calculateSuccessScore(tasks) <= 0.40 || ref.watch(isRescueModeActiveProvider))
                _buildRescueBanner(context, tasks, ref),

              // 2. Success Score Card
              _buildSuccessScoreCard(context, tasks),
              const SizedBox(height: 24),

              // 3. Today's Timeline
              _buildTimelineSection(context, schedule),
              const SizedBox(height: 24),

              // 4. AI Recommendations Card
              if (!isDismissed) ...[
                _buildAIRecommendations(context, ref, tasks),
                const SizedBox(height: 24),
              ],

              // 5. High Risk Tasks
              _buildHighRiskTasksSection(context, tasks),
            ],
          ),
        ),
      ),
    );
  }

  void _showUndoConfirmation(BuildContext context, WidgetRef ref) {
    int timeLeft = 5;
    Timer? timer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (timeLeft > 0) {
                setState(() => timeLeft--);
              } else {
                t.cancel();
              }
            });

            return AlertDialog(
              title: const Text('Undo Rescue Mode?'),
              content: const Text(
                'Are you sure you want to revert your schedule back to a critical state? '
                'The delayed tasks will be brought back to their original deadlines.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    timer?.cancel();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: timeLeft > 0
                      ? null
                      : () async {
                          final originalTasks = ref.read(rescueUndoStateProvider);
                          final tasksNotifier = ref.read(taskControllerProvider.notifier);
                          for (final task in originalTasks) {
                            await tasksNotifier.updateTask(task);
                          }
                          ref.read(isRescueModeActiveProvider.notifier).state = false;
                          ref.read(rescueUndoStateProvider.notifier).state = [];
                          
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Rescue Mode undone. Schedule critical.')),
                            );
                          }
                        },
                  child: Text(timeLeft > 0 ? 'Confirm ($timeLeft)' : 'Confirm'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) => timer?.cancel());
  }

  double _calculateSuccessScore(List<TaskEntity> tasks) {
    if (tasks.isEmpty) return 1.0;

    int totalTasks = tasks.where((t) => t.status != 'Delayed').length;
    if (totalTasks == 0) return 1.0;
    
    int completed = tasks.where((t) => t.status == 'Completed').length;
    int highRisk = tasks.where((t) => (t.riskScore ?? 0) > 60 && t.status != 'Delayed' && t.status != 'Completed').length;

    double completionFactor = completed / totalTasks;
    double riskPenalty = (highRisk / totalTasks) * 0.4; // up to 40% penalty

    double score = (0.6 + (completionFactor * 0.4)) - riskPenalty;
    if (score < 0.1) score = 0.1;
    if (score > 1.0) score = 1.0;
    return score;
  }

  Widget _buildRescueBanner(BuildContext context, List<TaskEntity> tasks, WidgetRef ref) {
    final isRescueActive = ref.watch(isRescueModeActiveProvider);

    if (isRescueActive) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withAlpha(80),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.shield_rounded, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🛡️ SCHEDULE STABILIZED',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rescue Mode active. Focus only on your pending tasks today.',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.undo_rounded, color: Colors.white),
              tooltip: 'Undo Rescue Mode',
              onPressed: () => _showUndoConfirmation(context, ref),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder:
              (ctx) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                child: RescueBottomSheet(tasks: tasks),
              ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withAlpha(80),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.white, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🚨 RESCUE MODE REQUIRED',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Schedule critical. Tap to initiate emergency recovery plan.',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScoreCard(BuildContext context, List<TaskEntity> tasks) {
    final theme = Theme.of(context);
    double score = _calculateSuccessScore(tasks);
    final scorePercent = (score * 100).toInt();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.primaryContainer.withAlpha(50),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: score,
                    strokeWidth: 8,
                    backgroundColor: theme.colorScheme.primary.withAlpha(40),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
                Text(
                  '$scorePercent%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Success Score",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    score > 0.7
                        ? 'Looking great! Your schedule is optimized for safe completion.'
                        : 'Attention needed. High-risk tasks are lowering your success chance.',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineSection(
    BuildContext context,
    List<ScheduleBlock> schedule,
  ) {
    final theme = Theme.of(context);

    if (schedule.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Timeline",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No schedule generated for today.\nGo to the Calendar tab to auto-plan!',
                ),
              ),
            ),
          ),
        ],
      );
    }

    final displayBlocks = schedule.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Timeline",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayBlocks.length,
              separatorBuilder: (context, index) => const Divider(indent: 72),
              itemBuilder: (context, index) {
                final block = displayBlocks[index];
                final isBreak = block.type == 'break';
                final timeStr =
                    '${block.startTime.hour.toString().padLeft(2, '0')}:${block.startTime.minute.toString().padLeft(2, '0')}';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              block.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    isBreak
                                        ? theme.colorScheme.onSurfaceVariant
                                        : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isBreak
                                        ? theme.colorScheme.tertiaryContainer
                                        : theme.colorScheme.primary.withAlpha(
                                          30,
                                        ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isBreak ? 'Break' : 'Focus Block',
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      isBreak
                                          ? theme
                                              .colorScheme
                                              .onTertiaryContainer
                                          : theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIRecommendations(
    BuildContext context,
    WidgetRef ref,
    List<TaskEntity> tasks,
  ) {
    final theme = Theme.of(context);
    final pendingTasks = tasks.where((t) => t.status != 'Completed' && t.status != 'Delayed').toList();
    final highRiskCount =
        pendingTasks.where((t) => (t.riskScore ?? 0) > 60).length;

    String title = "You're all caught up!";
    String reason =
        "No urgent tasks are pending. Consider taking a break or planning for tomorrow.";

    if (highRiskCount > 0) {
      title = "Tackle High Risk Tasks First";
      reason =
          "You have $highRiskCount high-risk tasks. Delaying them further will lower your success score and cause schedule overlap.";
    } else if (pendingTasks.isNotEmpty) {
      title = "Steady Progress";
      reason =
          "You have ${pendingTasks.length} tasks remaining. Follow your generated timeline to finish them efficiently.";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              "AI Recommendation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: theme.colorScheme.primary.withAlpha(80),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(reason, style: const TextStyle(fontSize: 13, height: 1.4)),
                const SizedBox(height: 12),
                if (pendingTasks.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Outcome: Stabilize Schedule',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Confidence: High',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        ref
                            .read(recommendationDismissedProvider.notifier)
                            .state = true;
                      },
                      child: const Text('Dismiss'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (highRiskCount > 0 || pendingTasks.isNotEmpty) {
                          ref
                              .read(navigationIndexProvider.notifier)
                              .setIndex(1); // 1 is Tasks tab
                          ref
                              .read(recommendationDismissedProvider.notifier)
                              .state = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Plan accepted! Head over to Tasks.',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Accept Plan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHighRiskTasksSection(
    BuildContext context,
    List<TaskEntity> tasks,
  ) {
    final theme = Theme.of(context);
    final highRiskTasks =
        tasks
            .where((t) => t.status != 'Completed' && (t.riskScore ?? 0) > 40)
            .toList()
          ..sort((a, b) => (b.riskScore ?? 0).compareTo(a.riskScore ?? 0));

    if (highRiskTasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "High Risk Tasks",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: highRiskTasks.take(3).length,
          itemBuilder: (context, index) {
            final task = highRiskTasks[index];
            final score = task.riskScore ?? 0;
            final color = score > 75 ? Colors.red : Colors.orange;

            final deadlineStr =
                '${task.deadline.month}/${task.deadline.day} ${task.deadline.hour.toString().padLeft(2, '0')}:${task.deadline.minute.toString().padLeft(2, '0')}';
            final diffHours = task.deadline.difference(DateTime.now()).inHours;
            final durationStr =
                diffHours > 0 ? '${diffHours}h remaining' : 'Overdue';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Risk: $score%',
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Deadline: $deadlineStr',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              durationStr,
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
