import '../entities/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> watchAllTasks();
  Stream<List<Task>> watchTasksByCategory(String categoryId);
  Future<Task?> getTaskById(String id);
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<List<Task>> searchTasks(String query);
  Future<List<Task>> getTasksDueToday();
}
