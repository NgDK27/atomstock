enum StockPriceDateFilter {
  oneDay('1D', Duration(days: 1), "Past day", '1d'),
  oneWeek('1W', Duration(days: 7), "Past week", '1w'),
  oneMonth('1M', Duration(days: 30), "Past month", '1m'),
  threeMonth('3M', Duration(days: 90), "Past 3 months", '3m'),
  sixMonth('6M', Duration(days: 180), "Past 6 months", '6m'),
  oneYear('1Y', Duration(days: 365), "Past year", '1y'),
  threeYear('3Y', Duration(days: 1095), "Past 3 years", '3y'),
  fiveYear('5Y', Duration(days: 5475), "Past 5 years", '5y');

  final String label;
  final Duration duration;
  final String description;
  final String serverParameter;

  const StockPriceDateFilter(this.label, this.duration, this.description, this.serverParameter);
}
