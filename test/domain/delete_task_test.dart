import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecases/delete_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late DeleteTaskUseCase useCase;
  late MockTaskRepository mockRepo;

  setUp(() {
    mockRepo = MockTaskRepository();
    useCase = DeleteTaskUseCase(mockRepo);
  });

  test('deletes task via repository', () async {
    when(() => mockRepo.deleteTask('test-id')).thenAnswer((_) async {});
    await useCase('test-id');
    verify(() => mockRepo.deleteTask('test-id')).called(1);
  });
}
