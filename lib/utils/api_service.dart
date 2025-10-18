import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> getAIQuote() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/quotes'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Just pick the first quote
      return data['quotes'][0]['quote'] ?? 'Your smart AI caption';
    } else {
      throw Exception('Failed to fetch AI caption');
    }
  }
}
