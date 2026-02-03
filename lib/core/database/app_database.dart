import 'package:housely/core/constants/text_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static AppDatabase? _instance;
  Database? _db;

  // ---------------------------------------------------------------------------
  // Singleton
  // ---------------------------------------------------------------------------
  AppDatabase._();

  factory AppDatabase() => _instance ??= AppDatabase._();

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, TextConstants.databaseName);

    return await openDatabase(
      path,
      version: TextConstants.version,
      onCreate: (db, version) async {
        await db.execute(TextConstants.createFavoritesTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Future migrations go here
        // Example: ALTER TABLE or CREATE new table
      },
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
