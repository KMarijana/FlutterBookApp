import 'dart:convert';

import 'package:http/http.dart' as http;

class QuoteProvider {
  QuoteProvider();

  Future<List<dynamic>> fetchQuotes() async {
    List quotes = [];
    final response = await http
        .get(
        Uri.parse('https://type.fit/api/quotes'));

    if (response.statusCode == 200) {
      return quotes = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
