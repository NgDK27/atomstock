import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
// package:oppenhomies/domain/models/stock/stock_model.dart

Future<StockModel> fetchStockData(String ticker) async {
  final response = await http.get(Uri.parse('http://192.168.1.193:8080/stock/$ticker'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON
    return StockModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load stock data');
  }
}

Future<StockModel> fetchHistoricalStockData(String ticker, String range) async {
  final response = await http.get(Uri.parse('http://192.168.1.193:8000/stock/$ticker?range=$range'));

  if (response.statusCode == 200) {
    // Parse the JSON response
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    // Convert to StockModel
    return StockModel.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load historical stock data');
  }
}
