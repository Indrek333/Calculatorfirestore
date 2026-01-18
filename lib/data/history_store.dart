import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/history_item.dart';

class HistoryStore {
  HistoryStore({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('calculator_history');

  Future<User> _ensureSignedIn() async {
    final current = _auth.currentUser;
    if (current != null) return current;
    final credentials = await _auth.signInAnonymously();
    return credentials.user!;
  }

  Future<void> add(HistoryItem item) async {
    final user = await _ensureSignedIn();
    final doc = _collection.doc();
    await doc.set({
      ...item.toFirestore(),
      'id': doc.id,
      'authorId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<HistoryItem>> getAll() async {
    final user = await _ensureSignedIn();
    final snapshot = await _collection
        .where('authorId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map(HistoryItem.fromFirestore).toList();
  }

  Future<void> clear() async {
    final user = await _ensureSignedIn();
    final snapshot =
        await _collection.where('authorId', isEqualTo: user.uid).get();
    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}