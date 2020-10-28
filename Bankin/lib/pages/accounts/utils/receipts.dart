class Receipts {
  final String store;
  final String category;
  final double price;

  const Receipts({this.store, this.category, this.price});
  
  factory Receipts.fromJson(Map<String, dynamic> parsedJson) {
    return Receipts(
      store: parsedJson['store'] as String,
      category: parsedJson['category'] as String,
      price: parsedJson['price'].toDouble() as double,
    );
  }
}