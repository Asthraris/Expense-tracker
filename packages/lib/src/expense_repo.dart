//Main Backend of App
import 'package:expense_repository/expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createTransaction(Transaction trans);
  Future<List<Transaction>> getTransaction();
}
