import 'package:movie_app/model/search_category.dart';

import 'movie.dart';

class DataModel {
  final List<Movie>? movies;
  final int? page;
  final String? searchCategory;
  final String? searchText;

  DataModel({this.movies, this.page, this.searchCategory, this.searchText});
  DataModel.inital()
      : movies = [],
        page = 1,
        searchCategory = SearchCategory.popular,
        searchText = '';

  DataModel copyWith({
    List<Movie>? movies,
    int? page,
    String? searchCategory,
    String? searchText,
  }) {
    return DataModel(
        movies: movies ?? this.movies,
        page: page ?? this.page,
        searchCategory: searchCategory ?? this.searchCategory,
        searchText: searchText ?? this.searchText);
  }
}
