import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<String> fetchHello() async {
    final response = await http.get(Uri.parse('$baseUrl/hello'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
