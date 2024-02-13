import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/movie.dart';

class MovieTile extends StatelessWidget {
  MovieTile({Key? key, this.height, this.weight, this.movie}) : super(key: key);
  final GetIt _getIt = GetIt.instance;
  final double? height;
  final double? weight;
  final Movie? movie;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _moviePosterWidget(movie!.posterURL()),
          _movieInfoWidget(),
        ],
      ),
    );
  }

  Widget _moviePosterWidget(String _imageUrl) {
    return Container(
      height: height,
      width: weight! * 0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imageUrl),
        ),
      ),
    );
  }

  Widget _movieInfoWidget() {
    return Container(
      height: height,
      width: weight! * 0.67,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: weight! * 0.56,
                child: Text(
                  movie!.name!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                movie!.rating.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height! * 0.02, 0, 0),
            child: Text(
              '${movie!.language!.toUpperCase()} | R: ${movie!.isAdult} | ${movie!.releaseDate}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height! * 0.07, 0, 0),
            child: Text(
              movie!.description!,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
