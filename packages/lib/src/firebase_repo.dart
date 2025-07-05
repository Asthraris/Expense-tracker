import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

import 'package:expense_repository/expense_repository.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final transCollection = FirebaseFirestore.instance.collection("Transactions");

  @override
  Future<void> createTransaction(Transaction trans) async {
    try {
      await transCollection
          .doc(trans.trans_id)
          .set(trans.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Transaction>> getTransaction({required String userId}) async {
    try {
      final querySnapshot = await transCollection
          .where('userId', isEqualTo: userId) // ✅ Filter by userId in Firestore
          .get();

      return querySnapshot.docs
          .map(
            (doc) => Transaction.fromEntity(
              TransactionEntity.fromDocument(doc.data()),
            ),
          )
          .toList();
    } catch (e) {
      log("Error fetching transactions: $e");
      rethrow;
    }
  }
}
