import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/history_item.dart';

class HistoryDb {
  static final HistoryDb instance = HistoryDb._();
  HistoryDb._();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calculator_history.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expression TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insert(HistoryItem item) async {
    final db = await database;
    await db.insert('history', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HistoryItem>> getAll() async {
    final db = await database;
    final rows = await db.query('history', orderBy: 'id DESC');
    return rows.map((r) => HistoryItem.fromMap(r)).toList();
  }

  Future<void> clear() async {
    final db = await database;
    await db.delete('history');
  }
}
