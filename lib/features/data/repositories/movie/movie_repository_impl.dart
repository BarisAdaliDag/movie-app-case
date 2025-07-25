import 'package:movieapp/features/data/datasources/movie/movie_remote_data_source.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/data/models/movie/movies_with_pagination_model.dart';
import 'package:movieapp/features/data/repositories/movie/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDatasource remoteDatasource;

  MovieRepositoryImpl({required this.remoteDatasource});

  @override
  Future<MoviesWithPaginationModel> getMovies({required String token, int page = 1}) {
    return remoteDatasource.getMovies(token: token, page: page);
  }

  @override
  Future<List<MovieModel>> getFavorites({required String token}) {
    return remoteDatasource.getFavorites(token: token);
  }

  @override
  Future<MovieModel> addFavorite({required String token, required String movieId}) {
    return remoteDatasource.addFavorite(token: token, movieId: movieId);
  }
}
