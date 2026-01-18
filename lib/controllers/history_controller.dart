import '../data/history_db.dart';
import '../models/history_item.dart';

class HistoryController {
  final HistoryDb _db = HistoryDb.instance;

  Future<List<HistoryItem>> getHistory() => _db.getAll();

  Future<void> addHistoryItem(HistoryItem item) => _db.insert(item);

  Future<void> clear() => _db.clear();
}
