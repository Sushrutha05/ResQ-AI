import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resq_ai/features/authentication/presentation/providers/auth_provider.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(FirebaseFirestore.instance);
});

final userTasksStreamProvider = StreamProvider.autoDispose<List<TaskEntity>>((ref) {
  final userState = ref.watch(authStateProvider);
  final user = userState.value;
  if (user == null) {
    return Stream.value(<TaskEntity>[]);
  }
  return ref.watch(taskRepositoryProvider).streamTasks(user.id);
});

final taskControllerProvider =
    AsyncNotifierProvider<TaskController, void>(() {
  return TaskController();
});

class TaskController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Return void
  }

  Future<void> createTask(TaskEntity task) async {
    state = const AsyncLoading();
    try {
      await ref.read(taskRepositoryProvider).createTask(task);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    state = const AsyncLoading();
    try {
      await ref.read(taskRepositoryProvider).updateTask(task);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> deleteTask(String taskId) async {
    state = const AsyncLoading();
    try {
      await ref.read(taskRepositoryProvider).deleteTask(taskId);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
