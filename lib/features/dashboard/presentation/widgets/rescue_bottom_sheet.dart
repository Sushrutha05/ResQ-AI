import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resq_ai/ai/rescue/rescue_models.dart';
import 'package:resq_ai/ai/rescue/rescue_provider.dart';
import 'package:resq_ai/features/tasks/domain/entities/task_entity.dart';
import 'package:resq_ai/features/tasks/presentation/providers/task_providers.dart';
import '../screens/dashboard_screen.dart';

class RescueBottomSheet extends ConsumerStatefulWidget {
  final List<TaskEntity> tasks;

  const RescueBottomSheet({super.key, required this.tasks});

  @override
  ConsumerState<RescueBottomSheet> createState() => _RescueBottomSheetState();
}

class _RescueBottomSheetState extends ConsumerState<RescueBottomSheet> {
  bool _isLoading = true;
  RecoveryPlan? _plan;
  bool _isAccepting = false;

  @override
  void initState() {
    super.initState();
    _fetchPlan();
  }

  Future<void> _fetchPlan() async {
    try {
      final agent = ref.read(rescueAgentProvider);
      final plan = await agent.generateRecoveryPlan(widget.tasks);
      if (mounted) {
        setState(() {
          _plan = plan;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate rescue plan: $e')),
        );
      }
    }
  }

  Future<void> _acceptPlan() async {
    setState(() {
      _isAccepting = true;
    });

    try {
      final tasksNotifier = ref.read(taskControllerProvider.notifier);

      // Delay the dropped tasks by pushing their deadline 1 day, or we can just mark them as delayed somehow.
      // For simplicity, let's add 24 hours to the deadlines of dropped tasks.
      final originalTasks = <TaskEntity>[];

      for (var id in _plan!.dropTaskIds) {
        final task = widget.tasks.firstWhere(
          (t) => t.taskId == id.trim(),
          orElse:
              () => TaskEntity(
                taskId: 'unknown',
                userId: 'unknown',
                title: 'Unknown Task',
                deadline: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                status: 'Pending',
              ),
        );

        if (task.taskId == 'unknown') continue;

        originalTasks.add(task);

        final newDeadline = task.deadline.add(const Duration(days: 1));

        final updatedTask = task.copyWith(
          deadline: newDeadline,
          status: 'Delayed',
          riskScore: null,
          riskExplanation: 'Delayed by Rescue Plan. Pending recalculation.',
        );

        await tasksNotifier.updateTask(updatedTask);
      }

      // Activate Rescue Mode flag for the Dashboard
      ref.read(rescueUndoStateProvider.notifier).state = originalTasks;
      ref.read(isRescueModeActiveProvider.notifier).state = true;

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Rescue Plan Accepted! Your schedule has been stabilized.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAccepting = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error accepting plan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Container(
        height: 300,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.red),
            const SizedBox(height: 24),
            Text(
              'Triaging your schedule...',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Finding the best path to recovery.',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    if (_plan == null) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(24),
        child: const Center(child: Text('Could not generate recovery plan.')),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recovery Plan Generated',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _plan!.emergencyAdvice,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            if (_plan!.dropTaskIds.isNotEmpty) ...[
              Text(
                'Tasks to Delay (Pushed by 24h):',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(_plan!.dropTaskIds.length, (index) {
                final id = _plan!.dropTaskIds[index];
                final reason =
                    _plan!.dropReasons.length > index
                        ? _plan!.dropReasons[index]
                        : 'Needs to be delayed.';

                // Find the task title
                final task = widget.tasks.firstWhere(
                  (t) => t.taskId == id,
                  orElse:
                      () => TaskEntity(
                        taskId: 'unknown',
                        userId: 'unknown',
                        title: 'Unknown Task',
                        deadline: DateTime.now(),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        status: 'Pending',
                      ),
                );

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  title: Text(
                    task.title,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text(
                    reason,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                );
              }),
            ] else ...[
              const Text('AI found no tasks to delay safely.'),
            ],
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _isAccepting ? null : _acceptPlan,
                child:
                    _isAccepting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Accept Triage Plan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel & Handle Manually'),
            ),
          ],
        ),
      ),
    );
  }
}
