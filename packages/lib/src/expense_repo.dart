//Main Backend of App
import 'package:flutter/foundation.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(Category category);
}
