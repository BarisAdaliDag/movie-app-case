import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/data/models/movie/movies_with_pagination_model.dart';

abstract class MovieRepository {
  Future<MoviesWithPaginationModel> getMovies({required String token, int page});
  Future<List<MovieModel>> getFavorites({required String token});
  Future<MovieModel> addFavorite({required String token, required String movieId});
}
