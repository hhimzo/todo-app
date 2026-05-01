import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/domain/entities/task.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecases/update_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late UpdateTaskUseCase useCase;
  late MockTaskRepository mockRepo;

  setUp(() {
    mockRepo = MockTaskRepository();
    useCase = UpdateTaskUseCase(mockRepo);
  });

  test('updates task via repository', () async {
    final task = Task(
      id: 'test-id',
      title: 'Updated task',
      isCompleted: true,
      priority: Priority.high,
      categoryId: 'work',
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 2),
    );

    when(() => mockRepo.updateTask(task)).thenAnswer((_) async {});
    await useCase(task);
    verify(() => mockRepo.updateTask(task)).called(1);
  });
}
