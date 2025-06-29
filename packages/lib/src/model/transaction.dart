import 'package:expense_repository/expense_repository.dart';

class Transaction {
  String trans_id;
  String category;
  DateTime date;
  int amount;
  String name;

  Transaction({
    required this.trans_id,
    required this.category,
    required this.date,
    required this.amount,
    required this.name,
  });

  TransactionEntity toEntity() {
    return TransactionEntity(
      category: category,
      name: name,
      amount: amount,
      date: date,
      trans_id: trans_id,
    );
  }

  static Transaction fromEntity(TransactionEntity entity) {
    return Transaction(
      trans_id: entity.trans_id,
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
      name: entity.name,
    );
  }
}
