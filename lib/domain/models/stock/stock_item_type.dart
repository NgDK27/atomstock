enum StockItemType {
  idx('index'),
  stock('stock');

  final String value;
  const StockItemType(this.value);

  @override
  String toString() => value;
}