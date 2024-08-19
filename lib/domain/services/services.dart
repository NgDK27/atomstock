import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiUrl =
      'http://192.168.1.193:5000/generate_response'; // local machine
  // final String apiUrl = 'http://10.240.226.135:5000/generate_response';
  Future<String> generateResponse(String prompt, String userId) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        print('Server responded with error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to generate response: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw e;
    }
  }
}
