import 'budgets.dart';
import 'receipts.dart';

class Finances {
  final List<Receipts> receipts;
  final List<Budgets> budgets;

  const Finances({this.receipts, this.budgets});

  factory Finances.fromJson(Map<String, dynamic> parsedJson) {
    var tmpReceipts = parsedJson['receipts'] as List;
    List<Receipts> receiptsList =
        tmpReceipts.map((i) => Receipts.fromJson(i)).toList();
    var tmpBudgets = parsedJson['budgets'] as List;
    List<Budgets> budgetsList =
        tmpBudgets.map((i) => Budgets.fromJson(i)).toList();
    return Finances(
      receipts: receiptsList,
      budgets: budgetsList,
    );
  }
}
