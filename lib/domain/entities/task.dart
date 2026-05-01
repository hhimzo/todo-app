import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

enum Priority { low, medium, high }

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    required bool isCompleted,
    required Priority priority,
    required String categoryId,
    DateTime? dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;
}
