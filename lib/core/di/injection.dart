import 'package:get_it/get_it.dart';
import '../../data/datasources/app_database.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/search_tasks.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Database
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  // Repositories
  getIt.registerSingleton<TaskRepository>(TaskRepositoryImpl(getIt()));
  getIt.registerSingleton<CategoryRepository>(
      CategoryRepositoryImpl(getIt()));

  // Use cases
  getIt.registerFactory(() => CreateTaskUseCase(getIt()));
  getIt.registerFactory(() => UpdateTaskUseCase(getIt()));
  getIt.registerFactory(() => DeleteTaskUseCase(getIt()));
  getIt.registerFactory(() => SearchTasksUseCase(getIt()));
}
