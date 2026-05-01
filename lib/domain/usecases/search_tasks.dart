import '../entities/task.dart';
import '../repositories/task_repository.dart';

class SearchTasksUseCase {
  final TaskRepository _repository;
  const SearchTasksUseCase(this._repository);

  Future<List<Task>> call(String query) => _repository.searchTasks(query);
}
