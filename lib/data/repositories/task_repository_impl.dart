import 'package:drift/drift.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/app_database.dart' as db;

class TaskRepositoryImpl implements TaskRepository {
  final db.AppDatabase _db;

  TaskRepositoryImpl(this._db);

  Task _rowToTask(db.Task row) => Task(
        id: row.id,
        title: row.title,
        description: row.description,
        isCompleted: row.isCompleted,
        priority: Priority.values.firstWhere((p) => p.name == row.priority),
        categoryId: row.categoryId,
        dueDate: row.dueDate,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  @override
  Stream<List<Task>> watchAllTasks() =>
      (_db.select(_db.tasks)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch()
          .map((rows) => rows.map(_rowToTask).toList());

  @override
  Stream<List<Task>> watchTasksByCategory(String categoryId) =>
      (_db.select(_db.tasks)
            ..where((t) => t.categoryId.equals(categoryId)))
          .watch()
          .map((rows) => rows.map(_rowToTask).toList());

  @override
  Future<Task?> getTaskById(String id) async {
    final row = await (_db.select(_db.tasks)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _rowToTask(row);
  }

  @override
  Future<void> createTask(Task task) async {
    await _db.into(_db.tasks).insert(db.TasksCompanion.insert(
          id: task.id,
          title: task.title,
          description: Value(task.description),
          isCompleted: Value(task.isCompleted),
          priority: Value(task.priority.name),
          categoryId: task.categoryId,
          dueDate: Value(task.dueDate),
          createdAt: task.createdAt,
          updatedAt: task.updatedAt,
        ));
  }

  @override
  Future<void> updateTask(Task task) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(task.id)))
        .write(
      db.TasksCompanion(
        title: Value(task.title),
        description: Value(task.description),
        isCompleted: Value(task.isCompleted),
        priority: Value(task.priority.name),
        categoryId: Value(task.categoryId),
        dueDate: Value(task.dueDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    final rows = await (_db.select(_db.tasks)
          ..where((t) =>
              t.title.like('%$query%') | t.description.like('%$query%')))
        .get();
    return rows.map(_rowToTask).toList();
  }

  @override
  Future<List<Task>> getTasksDueToday() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final rows = await (_db.select(_db.tasks)
          ..where((t) => t.dueDate.isBetweenValues(start, end)))
        .get();
    return rows.map(_rowToTask).toList();
  }
}
