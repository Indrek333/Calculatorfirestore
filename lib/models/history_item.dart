import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryItem {
  final String? id;
  final String expression;
  final String timestamp;
  final String? authorId;

  HistoryItem({
    this.id,
    required this.expression,
    required this.timestamp,
    this.authorId,
  });

  Map<String, Object?> toFirestore() => {
        'expression': expression,
        'timestamp': timestamp,
      };

  factory HistoryItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return HistoryItem(
      id: data['id'] as String? ?? doc.id,
      expression: data['expression'] as String? ?? '',
      timestamp: data['timestamp'] as String? ?? '',
      authorId: data['authorId'] as String?,
    );
  }
}