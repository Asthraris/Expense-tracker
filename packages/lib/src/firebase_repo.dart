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
  Future<List<Transaction>> getTransaction() async {
    try {
      return await transCollection.get().then(
        (value) => value.docs
            .map(
              (e) => Transaction.fromEntity(
                TransactionEntity.fromDocument(e.data()),
              ),
            )
            .toList(),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
