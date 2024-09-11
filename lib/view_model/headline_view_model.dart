import 'package:news_app/models/news_category_model.dart';

import '../controllers/fetch_headlines_controller.dart';
import '../models/headlins_model.dart';

class HeadlineViewModel {
  final _repo = HeadLineController();

  Future<Headlinesmodel> fetchHeadline(String name) async {
    final response = await _repo.fetchHeadline(name);
    return response;
  }

  Future<NewsCategoryModel> fetchCategories(String category) async {
    final response = await _repo.fetchCategories(category);
    return response;
  }
}
