import '../entities/task_entity.dart';

abstract class TaskRepository {
  Stream<List<TaskEntity>> streamTasks(String userId);
  Future<void> createTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String taskId);
}
