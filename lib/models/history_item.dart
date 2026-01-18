class HistoryItem {
  final int? id; 
  final String expression;
  final String timestamp;  

  HistoryItem({
    this.id,
    required this.expression,
    required this.timestamp,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'expression': expression,
        'timestamp': timestamp,
      };

  factory HistoryItem.fromMap(Map<String, Object?> map) => HistoryItem(
        id: map['id'] as int?,
        expression: map['expression'] as String,
        timestamp: map['timestamp'] as String,
      );
}
