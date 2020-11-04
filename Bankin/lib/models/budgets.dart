class Budgets {
  final String amount;
  final String category;

  const Budgets({this.amount, this.category});
  
  factory Budgets.fromJson(Map<String, dynamic> parsedJson) {
    return Budgets(
      amount: parsedJson['amount'] as String,
      category: parsedJson['category'] as String,
    );
  }
}