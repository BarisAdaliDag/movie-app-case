import 'package:movieapp/features/data/models/movie/movie_model.dart';

abstract class MovieRepository {
  Future<List<MovieModel>> getMovies({required String token, int page});
  Future<List<MovieModel>> getFavorites({required String token});
  Future<MovieModel> addFavorite({required String token, required String movieId});
}
