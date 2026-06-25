import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resq_ai/features/authentication/presentation/providers/auth_provider.dart';
import 'package:resq_ai/features/tasks/domain/entities/task_entity.dart';
import 'package:resq_ai/features/tasks/presentation/providers/task_providers.dart';

class TaskFormSheet extends ConsumerStatefulWidget {
  final TaskEntity? task;

  const TaskFormSheet({super.key, this.task});

  @override
  ConsumerState<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends ConsumerState<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDeadline;
  late String _priority;
  late int _estimatedDuration;

  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final List<int> _durationOptions = [15, 30, 45, 60, 90, 120, 180, 240, 300, 360];

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descriptionController = TextEditingController(text: t?.description ?? '');
    _selectedDeadline = t?.deadline ?? DateTime.now().add(const Duration(hours: 4));
    _priority = t?.priority ?? 'Medium';
    _estimatedDuration = t?.estimatedDuration ?? 60;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now().subtract(const Duration(days: 305)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;

    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDeadline = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User session not found. Please log in again.')),
      );
      return;
    }

    final now = DateTime.now();
    final isEdit = widget.task != null;

    final taskToSave = TaskEntity(
      taskId: widget.task?.taskId ?? '',
      userId: user.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      deadline: _selectedDeadline,
      priority: _priority,
      status: widget.task?.status ?? 'Pending',
      estimatedDuration: _estimatedDuration,
      actualDuration: widget.task?.actualDuration ?? 0,
      progress: widget.task?.progress ?? 0,
      createdBy: widget.task?.createdBy ?? 'user',
      createdAt: widget.task?.createdAt ?? now,
      updatedAt: now,
    );

    debugPrint('TaskFormSheet: Submitting task...');
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    final controller = ref.read(taskControllerProvider.notifier);
    if (isEdit) {
      await controller.updateTask(taskToSave);
    } else {
      await controller.createTask(taskToSave);
    }
    debugPrint('TaskFormSheet: Submit finished.');

    final controllerState = ref.read(taskControllerProvider);
    if (controllerState.hasError) {
      debugPrint('TaskFormSheet: Submit failed with error: ${controllerState.error}');
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to save task: ${controllerState.error}')),
      );
    } else {
      debugPrint('TaskFormSheet: Dismissing bottom sheet...');
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEdit ? 'Edit Task' : 'New Task',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                tileColor: theme.colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                leading: const Icon(Icons.calendar_today),
                title: const Text('Deadline'),
                subtitle: Text(_selectedDeadline.toLocal().toString().substring(0, 16)),
                trailing: TextButton(
                  onPressed: _pickDeadline,
                  child: const Text('Change'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: _priorities.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _priority = val;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _estimatedDuration,
                      decoration: const InputDecoration(
                        labelText: 'Duration (min)',
                        border: OutlineInputBorder(),
                      ),
                      items: _durationOptions.map((d) {
                        final hours = d >= 60 ? '${(d / 60).toStringAsFixed(1)}h' : '${d}m';
                        return DropdownMenuItem(
                          value: d,
                          child: Text(hours),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _estimatedDuration = val;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _submit,
                    child: Text(isEdit ? 'Save Changes' : 'Create Task'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
