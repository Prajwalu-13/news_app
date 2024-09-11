import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:news_app/models/news_category_model.dart';
import 'package:news_app/services/data_Constants.dart';

import '../models/headlins_model.dart';

class HeadLineController {
  Future<Headlinesmodel> fetchHeadline(String name) async {
    final response = await http.get(
      Uri.parse(
          '${DataConstants.baseUrl}top-headlines?sources=${name}&apiKey=${DataConstants.apiKey}'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Headlinesmodel.fromJson(data);
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<NewsCategoryModel> fetchCategories(String category) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${DataConstants.baseUrl}everything?q=${category}&apiKey=${DataConstants.apiKey}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return NewsCategoryModel.fromJson(data);
      } else {
        throw Exception('Failed to load news');
      }
    } on SocketException catch (_) {
      throw Exception('Network Connection issue !');
    } catch (e) {
      throw Exception('Failed to load news');
    }
  }
}
