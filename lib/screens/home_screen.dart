import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/model/data_model.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/search_category.dart';
import 'package:movie_app/widgets/movie_tile.dart';

import '../controllers/data_controller.dart';

final dataControllerProvider =
    StateNotifierProvider<DataController, DataModel>((ref) {
  return DataController();
});

final selectedMoviePosterURLProvider = StateProvider<String?>((ref) {
  final _movies = ref.watch(dataControllerProvider).movies!;
  return _movies.length != 0 ? _movies[0].posterURL() : null;
});

class HomeScreen extends ConsumerWidget {
  double? _deviceHeight;
  double? _deviceWidth;

  late var _selectedMoviePosterURL;
  late DataController _dataController;
  late DataModel _dataModel;

  TextEditingController? _searchTextFieldController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _searchTextFieldController = TextEditingController();
    _dataController = ref.watch(dataControllerProvider.notifier);
    _dataModel = ref.watch(dataControllerProvider);
    _searchTextFieldController!.text = _dataModel.searchText!;
    _selectedMoviePosterURL = ref.watch(selectedMoviePosterURLProvider);
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(),
            _foregroundWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    if (_selectedMoviePosterURL != null) {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(_selectedMoviePosterURL),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        color: Colors.black,
      );
    }
  }

  Widget _foregroundWidgets() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _deviceHeight! * 0.02, 0, 0),
      width: _deviceWidth! * 0.90,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          Container(
            height: _deviceHeight! * 0.83,
            padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.01),
            child: _movieListViewWidget(),
          ),
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight! * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchWidget(),
          _categorySelectionWidget(),
        ],
      ),
    );
  }

  Widget _searchWidget() {
    final _border = InputBorder.none;
    return Container(
      width: _deviceWidth! * 0.50,
      height: _deviceHeight! * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (_input) => _dataController.updateTextSearch(_input),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: _border,
          border: _border,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white24,
          ),
          hintStyle: const TextStyle(color: Colors.white54),
          filled: false,
          fillColor: Colors.white24,
          hintText: 'Search....',
        ),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _dataModel.searchCategory,
      icon: const Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      onChanged: (dynamic _value) => _value.toString().isNotEmpty
          ? _dataController.updateSearchCategory(_value)
          : null,
      items: [
        DropdownMenuItem(
          child: Text(
            SearchCategory.popular,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          value: SearchCategory.popular,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.upcoming,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          value: SearchCategory.upcoming,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.none,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          value: SearchCategory.none,
        ),
      ],
    );
  }

  Widget _movieListViewWidget() {
    final List<Movie> _movies = _dataModel.movies!;

    if (_movies.length != 0) {
      return NotificationListener(
        onNotification: (dynamic _onScrollNotification) {
          if (_onScrollNotification is ScrollEndNotification) {
            final before = _onScrollNotification.metrics.extentBefore;
            final max = _onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              _dataController.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext _context, int _count) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: _deviceHeight! * 0.01, horizontal: 0),
                child: GestureDetector(
                  onTap: () {
                    _selectedMoviePosterURL.state = _movies[_count].posterURL();
                  },
                  child: MovieTile(
                    movie: _movies[_count],
                    height: _deviceHeight! * 0.20,
                    weight: _deviceWidth! * 0.85,
                  ),
                ),
              );
            }),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
