import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:expense_repository/expense_repository.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final expensesCollection = FirebaseFirestore.instance.collection("Expenses");

  @override
  Future<void> createCategory(Category category) async {
    try {} catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
