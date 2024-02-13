import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/model/data_model.dart';
import 'package:movie_app/model/search_category.dart';

import '../model/movie.dart';
import '../services/movie_service.dart';

class DataController extends StateNotifier<DataModel> {
  DataController([DataModel? state]) : super(state ?? DataModel.inital()) {
    getMovies();
  }
  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie>? _movies = [];
      if (state.searchText!.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          _movies = await _movieService.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = await _movieService.getUpcomingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.none) {
          _movies = [];
        } else {
          _movies = await _movieService.searchMovies(state.searchText);
        }
      }
      _movies = await _movieService.getPopularMovies(page: state.page);
      state = state.copyWith(
        movies: [...state.movies!, ..._movies!],
        page: state.page! + 1,
      );
    } catch (e) {}
  }

  void updateSearchCategory(String _category) {
    try {
      state = state.copyWith(
        movies: [],
        page: 1,
        searchCategory: _category,
        searchText: '',
      );
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String _searchText) {
    try {
      state = state.copyWith(
          movies: [],
          page: 1,
          searchCategory: SearchCategory.none,
          searchText: _searchText);
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}
