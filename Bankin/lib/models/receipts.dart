class Receipts {
  final String store;
  final String category;
  final int date;
  final double price;

  const Receipts({this.store, this.category, this.date, this.price});
  
  factory Receipts.fromJson(Map<String, dynamic> parsedJson) {
    return Receipts(
      store: parsedJson['store'] as String,
      category: parsedJson['category'] as String,
      date: parsedJson['date'] as int,
      price: parsedJson['price'].toDouble() as double,
    );
  }
}