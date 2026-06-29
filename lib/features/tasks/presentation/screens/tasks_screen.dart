import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resq_ai/features/tasks/domain/entities/task_entity.dart';
import 'package:resq_ai/features/tasks/presentation/providers/task_providers.dart';
import 'package:resq_ai/features/tasks/presentation/widgets/task_form_sheet.dart';
import 'package:resq_ai/ai/risk/risk_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  String _statusFilter = 'All';
  String? _assessingRiskId;

  void _showSubtasksSheet(BuildContext context, TaskEntity task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtasks for "${task.title}"',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (task.subtasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No subtasks available.'),
                    )
                  else
                    ...task.subtasks.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final subtask = entry.value;
                      return CheckboxListTile(
                        value: subtask.isCompleted,
                        title: Text(
                          subtask.title,
                          style: TextStyle(
                            decoration:
                                subtask.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                            color:
                                subtask.isCompleted
                                    ? theme.colorScheme.onSurfaceVariant
                                    : null,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (val) {
                          if (val == null) return;

                          // Update locally for instant feedback in modal
                          setModalState(() {
                            final updatedSubtasks = List<SubtaskEntity>.from(
                              task.subtasks,
                            );
                            updatedSubtasks[idx] = subtask.copyWith(
                              isCompleted: val,
                            );

                            // Save to Firestore
                            final updatedTask = task.copyWith(
                              subtasks: updatedSubtasks,
                              updatedAt: DateTime.now(),
                            );
                            ref
                                .read(taskControllerProvider.notifier)
                                .updateTask(updatedTask);
                          });
                        },
                      );
                    }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Color _getRiskColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  Future<void> _assessRisk(TaskEntity task) async {
    setState(() => _assessingRiskId = task.taskId);
    try {
      final riskAgent = ref.read(riskAgentProvider);
      final assessment = await riskAgent.assessTaskRisk(task);

      final updatedTask = task.copyWith(
        riskScore: assessment.score,
        riskExplanation: assessment.explanation,
      );

      await ref.read(taskControllerProvider.notifier).updateTask(updatedTask);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Risk assessed: ${assessment.score}%')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error assessing risk: $e')));
    } finally {
      if (mounted) setState(() => _assessingRiskId = null);
    }
  }

  void _showFormSheet([TaskEntity? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TaskFormSheet(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksStream = ref.watch(userTasksStreamProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending'),
                const SizedBox(width: 8),
                _buildFilterChip('In Progress'),
                const SizedBox(width: 8),
                _buildFilterChip('Delayed'),
                const SizedBox(width: 8),
                _buildFilterChip('Completed'),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Tasks Stream list
          Expanded(
            child: tasksStream.when(
              data: (tasks) {
                final filteredTasks =
                    tasks.where((t) {
                      if (_statusFilter == 'All') return true;
                      return t.status == _statusFilter;
                    }).toList();

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      filteredTasks.isEmpty
                          ? Center(
                            key: const ValueKey('empty_state'),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.task_alt,
                                    size: 64,
                                    color: theme.colorScheme.onSurfaceVariant
                                        .withAlpha(100),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No tasks found',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _statusFilter == 'All'
                                        ? "Let's create your first task by tapping the + button!"
                                        : "No tasks match your selected filter.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : ListView.builder(
                            key: ValueKey('list_$_statusFilter'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];
                              final priorityColor = _getPriorityColor(
                                task.priority,
                              );
                              final isCompleted = task.status == 'Completed';

                              return Dismissible(
                                key: ValueKey(task.taskId),
                                background: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                secondaryBackground: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    ref
                                        .read(taskControllerProvider.notifier)
                                        .updateTask(
                                          task.copyWith(
                                            status:
                                                isCompleted
                                                    ? 'Pending'
                                                    : 'Completed',
                                            progress: isCompleted ? 0 : 100,
                                          ),
                                        );
                                    return false; // Snap back, let Riverpod handle the rebuild
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (ctx) => AlertDialog(
                                            title: const Text('Delete Task'),
                                            content: const Text(
                                              'Are you sure you want to delete this task?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      ctx,
                                                    ).pop(false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                ),
                                                onPressed:
                                                    () => Navigator.of(
                                                      ctx,
                                                    ).pop(true),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirm == true) {
                                      ref
                                          .read(taskControllerProvider.notifier)
                                          .deleteTask(task.taskId);
                                      return true;
                                    }
                                    return false;
                                  }
                                  return false;
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 12.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          value: isCompleted,
                                          onChanged: (val) {
                                            if (val != null) {
                                              ref
                                                  .read(
                                                    taskControllerProvider
                                                        .notifier,
                                                  )
                                                  .updateTask(
                                                    task.copyWith(
                                                      status:
                                                          val
                                                              ? 'Completed'
                                                              : 'Pending',
                                                      progress: val ? 100 : 0,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task.title,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      isCompleted
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                  color:
                                                      isCompleted
                                                          ? theme
                                                              .colorScheme
                                                              .onSurfaceVariant
                                                          : null,
                                                ),
                                              ),
                                              if (task
                                                  .description
                                                  .isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  task.description,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color:
                                                        theme
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                              Wrap(
                                                spacing: 12,
                                                runSpacing: 4,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: priorityColor
                                                          .withAlpha(30),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      task.priority,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: priorityColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  if (task.riskScore !=
                                                      null) ...[
                                                    Tooltip(
                                                      message:
                                                          task.riskExplanation ??
                                                          '',
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: _getRiskColor(
                                                            task.riskScore!,
                                                          ).withAlpha(30),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          'Risk: ${task.riskScore}%',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: _getRiskColor(
                                                              task.riskScore!,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  if (task
                                                      .subtasks
                                                      .isNotEmpty) ...[
                                                    InkWell(
                                                      onTap:
                                                          () =>
                                                              _showSubtasksSheet(
                                                                context,
                                                                task,
                                                              ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 2,
                                                            ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .format_list_bulleted,
                                                              size: 13,
                                                              color:
                                                                  theme
                                                                      .colorScheme
                                                                      .primary,
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              '${task.subtasks.length} subtasks',
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    theme
                                                                        .colorScheme
                                                                        .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.calendar_today,
                                                        size: 13,
                                                        color:
                                                            theme
                                                                .colorScheme
                                                                .onSurfaceVariant,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        task.deadline
                                                            .toLocal()
                                                            .toString()
                                                            .substring(0, 16),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              theme
                                                                  .colorScheme
                                                                  .onSurfaceVariant,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        _assessingRiskId == task.taskId
                                            ? const Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            )
                                            : IconButton(
                                              icon: const Icon(
                                                Icons.analytics_outlined,
                                                color: Colors.purple,
                                              ),
                                              tooltip: 'Assess Risk',
                                              onPressed:
                                                  () => _assessRisk(task),
                                            ),
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (value) {
                                            if (value == 'edit')
                                              _showFormSheet(task);
                                            if (value == 'delete')
                                              _confirmDelete(task.taskId);
                                          },
                                          itemBuilder:
                                              (context) => [
                                                const PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit_outlined,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete_outline,
                                                        size: 20,
                                                        color: Colors.redAccent,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animate(key: ValueKey('anim_${task.taskId}')).fade().slideX(begin: 0.05);
                            },
                          ),
                );
              },
              error:
                  (err, stack) =>
                      Center(child: Text('Error loading tasks: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        onPressed: () => _showFormSheet(),
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _statusFilter == filter;
    return ChoiceChip(
      label: Text(filter),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          setState(() {
            _statusFilter = filter;
          });
        }
      },
    );
  }

  void _confirmDelete(String taskId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  ref.read(taskControllerProvider.notifier).deleteTask(taskId);
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
