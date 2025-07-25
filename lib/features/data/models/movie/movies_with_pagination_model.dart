import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/data/models/movie/pagination_model.dart';

class MoviesWithPaginationModel {
  final List<MovieModel> movies;
  final PaginationModel pagination;

  MoviesWithPaginationModel({required this.movies, required this.pagination});
}
