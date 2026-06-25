import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl(this._firestore);

  @override
  Stream<List<TaskEntity>> streamTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Fallback to doc ID if taskId is missing in document data
        if (data['taskId'] == null || data['taskId'].toString().isEmpty) {
          data['taskId'] = doc.id;
        }
        return TaskEntity.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> createTask(TaskEntity task) async {
    final docRef = _firestore.collection('tasks').doc();
    final taskWithId = task.copyWith(
      taskId: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await docRef.set(taskWithId.toJson());
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final updatedTask = task.copyWith(updatedAt: DateTime.now());
    await _firestore
        .collection('tasks')
        .doc(task.taskId)
        .update(updatedTask.toJson());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
