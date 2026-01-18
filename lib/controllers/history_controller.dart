import '../data/history_store.dart';
import '../models/history_item.dart';

class HistoryController {
  final HistoryStore _store = HistoryStore();

  Future<List<HistoryItem>> getHistory() => _store.getAll();

  Future<void> addHistoryItem(HistoryItem item) => _store.add(item);

  Future<void> clear() => _store.clear();
}