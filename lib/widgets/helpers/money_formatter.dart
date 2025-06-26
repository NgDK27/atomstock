import 'package:currency_formatter/currency_formatter.dart';

extension VNDCurrencyFormatter on double {

  String vndFormat() {
    final CurrencyFormat vndSettings = CurrencyFormat(
      code: 'vnd',
      symbol: '₫',
      symbolSide: SymbolSide.right,
      thousandSeparator: '.',
      decimalSeparator: ',',
      symbolSeparator: ' ',
    );

    return CurrencyFormatter.format(this, vndSettings, decimal: 0);
  }

  String vndNoSymbolFormat() {
    final CurrencyFormat vndSettings = CurrencyFormat(
      code: 'vnd',
      symbol: '₫',
      symbolSide: SymbolSide.none, // No symbol
      thousandSeparator: '.',
      decimalSeparator: ',',
      symbolSeparator: ' ',
    );

    return CurrencyFormatter.format(this, vndSettings, decimal: 0);
  }

  String vndCompactFormat() {
    final CurrencyFormat vndSettings = CurrencyFormat(
      code: 'vnd',
      symbol: '₫',
      symbolSide: SymbolSide.right,
      thousandSeparator: '.',
      decimalSeparator: ',',
      symbolSeparator: ' ',
    );

    return CurrencyFormatter.format(this, vndSettings, compact: true, decimal: 3);
  }
}