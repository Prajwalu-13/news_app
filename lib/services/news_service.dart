import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/services/data_Constants.dart';

class NewsService {
  Future<List<dynamic>> searchNews(String query) async {
    final response = await http.get(
      Uri.parse(
          '${DataConstants.baseUrl}everything?q=$query&apiKey=${DataConstants.apiKey}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to search news');
    }
  }
}
