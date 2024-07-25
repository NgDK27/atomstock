

import 'package:money_formatter/money_formatter.dart';

extension CurrencyFormatter on double {

  String vndFormat() {
    final MoneyFormatter fmf = MoneyFormatter(
        amount: this,
        settings: MoneyFormatterSettings(
            symbol: '₫',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 0,
            compactFormatType: CompactFormatType.short,
        ),
    );

    return fmf.output.symbolOnRight;
  }

  String vndNoSymbolFormat() {
    final MoneyFormatter fmf = MoneyFormatter(
      amount: this,
      settings: MoneyFormatterSettings(
        symbol: '₫',
        thousandSeparator: '.',
        decimalSeparator: ',',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 0,
        compactFormatType: CompactFormatType.short,
      ),
    );

    return fmf.output.nonSymbol;
  }

  String vndCompactFormat() {
    final MoneyFormatter fmf = MoneyFormatter(
        amount: this,
        settings: MoneyFormatterSettings(
            symbol: '₫',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 3,
            compactFormatType: CompactFormatType.short,
        ),
    );

    return fmf.output.compactSymbolOnRight;
  }
}