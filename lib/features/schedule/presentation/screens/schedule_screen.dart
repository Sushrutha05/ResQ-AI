import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resq_ai/ai/scheduler/scheduler_provider.dart';
import 'package:resq_ai/features/tasks/presentation/providers/task_providers.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  bool _isGenerating = false;

  Future<void> _generateSchedule() async {
    print('DEBUG: _generateSchedule started.');
    final tasksList = await ref.read(userTasksStreamProvider.future);
    print('DEBUG: Fetched ${tasksList.length} total tasks from stream.');
    final pendingTasks = tasksList.where((t) => t.status != 'Completed').toList();
    print('DEBUG: Filtered to ${pendingTasks.length} pending tasks.');
    
    if (pendingTasks.isEmpty) {
      print('DEBUG: No pending tasks. Aborting.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pending tasks to schedule!')),
      );
      return;
    }

    setState(() => _isGenerating = true);
    
    try {
      print('DEBUG: Calling scheduler agent...');
      final scheduler = ref.read(schedulerAgentProvider);
      final schedule = await scheduler.generateSchedule(pendingTasks);
      print('DEBUG: Generated ${schedule.length} schedule blocks. Updating state.');
      
      ref.read(generatedScheduleProvider.notifier).updateSchedule(schedule);
      
    } catch (e, stack) {
      print('DEBUG: Exception caught: $e\n$stack');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate schedule: $e')),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep the autoDispose stream alive so we don't get a StateError when reading its future
    ref.watch(userTasksStreamProvider);
    
    final schedule = ref.watch(generatedScheduleProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Scheduler'),
        actions: [
          if (schedule.isNotEmpty && !_isGenerating)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _generateSchedule,
              tooltip: 'Regenerate Schedule',
            )
        ],
      ),
      body: _isGenerating
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('AI is planning your day...', style: theme.textTheme.bodyLarge),
                ],
              ),
            )
          : schedule.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month, size: 64, color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
                      const SizedBox(height: 16),
                      Text('No schedule generated yet.', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Auto-Plan My Day'),
                        onPressed: _generateSchedule,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final block = schedule[index];
                    final isBreak = block.type == 'break';
                    
                    final startStr = '${block.startTime.hour.toString().padLeft(2, '0')}:${block.startTime.minute.toString().padLeft(2, '0')}';
                    final endStr = '${block.endTime.hour.toString().padLeft(2, '0')}:${block.endTime.minute.toString().padLeft(2, '0')}';
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: isBreak ? theme.colorScheme.tertiaryContainer.withAlpha(50) : theme.colorScheme.surfaceContainer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isBreak ? theme.colorScheme.tertiary.withAlpha(100) : theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          isBreak ? Icons.coffee : Icons.task_alt,
                          color: isBreak ? theme.colorScheme.tertiary : theme.colorScheme.primary,
                        ),
                        title: Text(
                          block.title,
                          style: TextStyle(
                            fontWeight: isBreak ? FontWeight.normal : FontWeight.bold,
                            color: isBreak ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text('$startStr - $endStr'),
                        trailing: isBreak 
                            ? null
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Focus Block',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
