import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionEntity {
  String trans_id;
  String category;
  DateTime date;
  int amount;
  String name;
  int card;
  String userId;

  TransactionEntity({
    required this.trans_id,
    required this.category,
    required this.date,
    required this.amount,
    required this.name,
    required this.card,
    required this.userId,
  });

  Map<String, Object?> toDocument() {
    return {
      'trans_id': trans_id,
      'category': category,
      'date': date,
      'amount': amount,
      'name': name,
      'card': card,
      'userId': userId,
    };
  }

  static TransactionEntity fromDocument(Map<String, dynamic> doc) {
    return TransactionEntity(
      name: doc['name'],
      trans_id: doc['trans_id'],
      category: doc['category'],
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount'],
      card: doc['card'],
      userId: doc['userId'],
    );
  }
}
