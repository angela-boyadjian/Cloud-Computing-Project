import 'budgets.dart';
import 'receipts.dart';

class Finances {
  final List<Receipts> receipts;
  final List<Budgets> budgets;

  const Finances({this.receipts, this.budgets});
  
  factory Finances.fromJson(Map<String, dynamic> parsedJson) {
    return Finances(
      // receipts: parsedJson['store'] as String,
      // budgets: parsedJson['category'] as String,
    );
  }
}