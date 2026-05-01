import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../../core/constants/app_constants.dart';

part 'app_database.g.dart';

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
  TextColumn get priority => text().withDefault(const Constant('low'))();
  TextColumn get categoryId => text()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Tasks, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => AppConstants.dbVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultCategories();
        },
      );

  Future<void> _seedDefaultCategories() async {
    final defaults = [
      CategoriesCompanion.insert(
          id: 'personal', name: 'Personal', colorValue: 0xFF2196F3),
      CategoriesCompanion.insert(
          id: 'work', name: 'Work', colorValue: 0xFF9C27B0),
      CategoriesCompanion.insert(
          id: 'shopping', name: 'Shopping', colorValue: 0xFF4CAF50),
      CategoriesCompanion.insert(
          id: 'health', name: 'Health', colorValue: 0xFFF44336),
    ];
    for (final cat in defaults) {
      await into(categories).insertOnConflictUpdate(cat);
    }
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: AppConstants.dbName);
}
