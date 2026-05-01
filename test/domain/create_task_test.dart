import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/domain/entities/task.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecases/create_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late CreateTaskUseCase useCase;
  late MockTaskRepository mockRepo;

  setUp(() {
    mockRepo = MockTaskRepository();
    useCase = CreateTaskUseCase(mockRepo);
  });

  test('creates task via repository', () async {
    final task = Task(
      id: 'test-id',
      title: 'Buy groceries',
      isCompleted: false,
      priority: Priority.medium,
      categoryId: 'personal',
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    when(() => mockRepo.createTask(task)).thenAnswer((_) async {});
    await useCase(task);
    verify(() => mockRepo.createTask(task)).called(1);
  });
}
