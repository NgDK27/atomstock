import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/domain/models/stock/stock_change_enum.dart';
import 'package:oppenhomies/styles/colors.dart';

Color determineStockChangeColor(
        {required BuildContext context, required StockChange? change,}) =>
    switch (change) {
      StockChange.increase => OpDynamicColor.aquaHarmonized(context),
      StockChange.decrease => OpDynamicColor.cherryHarmonized(context),
      null => OpDynamicColor.onSurface(context),
    };
