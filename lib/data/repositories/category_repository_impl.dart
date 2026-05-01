import 'package:drift/drift.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/app_database.dart' as db;

class CategoryRepositoryImpl implements CategoryRepository {
  final db.AppDatabase _db;
  CategoryRepositoryImpl(this._db);

  Category _rowToCategory(db.Category row) =>
      Category(id: row.id, name: row.name, colorValue: row.colorValue);

  @override
  Stream<List<Category>> watchAllCategories() =>
      _db.select(_db.categories).watch().map(
          (rows) => rows.map(_rowToCategory).toList());

  @override
  Future<void> createCategory(Category category) async {
    await _db.into(_db.categories).insert(db.CategoriesCompanion.insert(
          id: category.id,
          name: category.name,
          colorValue: category.colorValue,
        ));
  }

  @override
  Future<void> updateCategory(Category category) async {
    await (_db.update(_db.categories)
          ..where((c) => c.id.equals(category.id)))
        .write(
      db.CategoriesCompanion(
        name: Value(category.name),
        colorValue: Value(category.colorValue),
      ),
    );
  }

  @override
  Future<void> deleteCategory(String id) async {
    await (_db.delete(_db.categories)..where((c) => c.id.equals(id))).go();
  }
}
