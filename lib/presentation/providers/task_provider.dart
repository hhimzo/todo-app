import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

final taskRepositoryProvider =
    Provider<TaskRepository>((ref) => getIt());

final allTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(taskRepositoryProvider).watchAllTasks();
});

final filteredTasksProvider =
    Provider.family<AsyncValue<List<Task>>, TaskFilter>((ref, filter) {
  final tasks = ref.watch(allTasksProvider);
  return tasks.whenData((list) {
    var result = list;
    if (filter.categoryId != null) {
      result =
          result.where((t) => t.categoryId == filter.categoryId).toList();
    }
    if (filter.priority != null) {
      result =
          result.where((t) => t.priority == filter.priority).toList();
    }
    if (filter.showCompleted != null) {
      result = result
          .where((t) => t.isCompleted == filter.showCompleted)
          .toList();
    }
    if (filter.query != null && filter.query!.isNotEmpty) {
      final q = filter.query!.toLowerCase();
      result = result
          .where((t) =>
              t.title.toLowerCase().contains(q) ||
              (t.description?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    return result;
  });
});

class TaskFilter {
  final String? categoryId;
  final Priority? priority;
  final bool? showCompleted;
  final String? query;

  const TaskFilter({
    this.categoryId,
    this.priority,
    this.showCompleted,
    this.query,
  });

  @override
  bool operator ==(Object other) =>
      other is TaskFilter &&
      other.categoryId == categoryId &&
      other.priority == priority &&
      other.showCompleted == showCompleted &&
      other.query == query;

  @override
  int get hashCode =>
      Object.hash(categoryId, priority, showCompleted, query);
}
