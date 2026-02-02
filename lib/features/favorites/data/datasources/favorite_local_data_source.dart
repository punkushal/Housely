import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../model/favorite_model.dart';

class FavoritesLocalDatasource {
  final AppDatabase _appDatabase;

  const FavoritesLocalDatasource(this._appDatabase);

  static const String _table = 'favorites';

  Future<Database> get _db async => await _appDatabase.database;

  // -----------------------------------------------------------------
  // INSERT — uses REPLACE so re-favoriting the same item is safe
  // -----------------------------------------------------------------
  Future<void> insert(FavoriteModel model) async {
    final db = await _db;
    await db.rawInsert(
      '''INSERT OR REPLACE INTO $_table
         (favorite_id, property, added_at)
         VALUES (?, ?, ?)''',
      [model.favoriteId, model.property, model.addedAtEpoch],
    );
  }

  // -----------------------------------------------------------------
  // DELETE by remote_id
  // -----------------------------------------------------------------
  Future<void> delete(String favoritId) async {
    final db = await _db;
    await db.delete(_table, where: 'favorite_id = ?', whereArgs: [favoritId]);
  }

  // -----------------------------------------------------------------
  // SELECT ALL — ordered by most recently added
  // -----------------------------------------------------------------
  Future<List<FavoriteModel>> getAll() async {
    final db = await _db;
    final rows = await db.query(_table, orderBy: 'added_at DESC');
    return rows.map(FavoriteModel.fromMap).toList();
  }

  // -----------------------------------------------------------------
  // EXISTS check
  // -----------------------------------------------------------------
  Future<bool> exists(String favoritId) async {
    final db = await _db;
    final rows = await db.query(
      _table,
      where: 'favorite_id = ?',
      whereArgs: [favoritId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
}
