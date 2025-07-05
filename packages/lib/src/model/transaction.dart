import 'package:expense_repository/expense_repository.dart';

class Transaction {
  String trans_id;
  String category;
  DateTime date;
  int amount;
  String name;
  int card;
  String userId;

  Transaction({
    required this.trans_id,
    required this.category,
    required this.date,
    required this.amount,
    required this.name,
    required this.card,
    required this.userId,
  });

  static final empty = Transaction(
    trans_id: "",
    category: "",
    date: DateTime.now(),
    amount: 0,
    name: "",
    card: -1,
    userId: "",
  );

  TransactionEntity toEntity() {
    return TransactionEntity(
      category: category,
      name: name,
      amount: amount,
      date: date,
      trans_id: trans_id,
      card: card,
      userId: userId,
    );
  }

  static Transaction fromEntity(TransactionEntity entity) {
    return Transaction(
      trans_id: entity.trans_id,
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
      name: entity.name,
      card: entity.card,
      userId: entity.userId,
    );
  }
}
