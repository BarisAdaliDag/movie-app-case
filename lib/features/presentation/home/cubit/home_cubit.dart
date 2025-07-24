import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/utils/secure_storage.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/data/repositories/movie/movie_repository.dart';
import 'package:movieapp/features/presentation/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MovieRepository movieRepository;

  HomeCubit({required this.movieRepository}) : super(const HomeState());

  Future<void> loadMovies({bool isRefresh = false}) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        emit(state.copyWith(error: 'Token bulunamadı', isLoading: false, isRefreshing: false, isInitial: false));
        return;
      }

      if (isRefresh) {
        emit(state.copyWith(isRefreshing: true, error: null));
      } else {
        emit(state.copyWith(isLoading: true, error: null, isInitial: false));
      }

      final movies = await movieRepository.getMovies(token: token, page: 1);

      emit(
        state.copyWith(
          movies: movies,
          currentPage: 1,
          hasReachedMax: movies.length < 5, // API her sayfada 5 film gönderiyor
          isLoading: false,
          isRefreshing: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false, isRefreshing: false, isInitial: false));
    }
  }

  Future<void> loadMoreMovies() async {
    if (!state.canLoadMore) return;

    try {
      final token = await SecureStorage.getToken();
      if (token == null) return;

      emit(state.copyWith(isLoadingMore: true));

      final newPage = state.currentPage + 1;
      final newMovies = await movieRepository.getMovies(token: token, page: newPage);

      final allMovies = [...state.movies, ...newMovies];

      emit(
        state.copyWith(
          movies: allMovies,
          currentPage: newPage,
          isLoadingMore: false,
          hasReachedMax: newMovies.length < 5,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: 'Daha fazla film yüklenirken hata oluştu'));
    }
  }

  Future<void> refreshMovies() async {
    await loadMovies(isRefresh: true);
  }

  Future<void> toggleFavorite(String movieId) async {
    if (state.isLoading) return;

    try {
      final token = await SecureStorage.getToken();
      if (token == null) return;

      // Optimistic update - favori durumunu hemen değiştir
      final updatedMovies =
          state.movies.map((movie) {
            if (movie.id == movieId) {
              return MovieModel(
                id: movie.id,
                title: movie.title,
                year: movie.year,
                rated: movie.rated,
                released: movie.released,
                runtime: movie.runtime,
                genre: movie.genre,
                director: movie.director,
                writer: movie.writer,
                actors: movie.actors,
                plot: movie.plot,
                language: movie.language,
                country: movie.country,
                awards: movie.awards,
                poster: movie.poster,
                metascore: movie.metascore,
                imdbRating: movie.imdbRating,
                imdbVotes: movie.imdbVotes,
                imdbID: movie.imdbID,
                type: movie.type,
                response: movie.response,
                images: movie.images,
                comingSoon: movie.comingSoon,
                isFavorite: !movie.isFavorite, // Toggle favori durumu
              );
            }
            return movie;
          }).toList();

      emit(state.copyWith(movies: updatedMovies));

      // API call - favori durumunu server'a gönder
      await movieRepository.addFavorite(token: token, movieId: movieId);
    } catch (e) {
      // Hata durumunda optimistic update'i geri al
      final revertedMovies =
          state.movies.map((movie) {
            if (movie.id == movieId) {
              return MovieModel(
                id: movie.id,
                title: movie.title,
                year: movie.year,
                rated: movie.rated,
                released: movie.released,
                runtime: movie.runtime,
                genre: movie.genre,
                director: movie.director,
                writer: movie.writer,
                actors: movie.actors,
                plot: movie.plot,
                language: movie.language,
                country: movie.country,
                awards: movie.awards,
                poster: movie.poster,
                metascore: movie.metascore,
                imdbRating: movie.imdbRating,
                imdbVotes: movie.imdbVotes,
                imdbID: movie.imdbID,
                type: movie.type,
                response: movie.response,
                images: movie.images,
                comingSoon: movie.comingSoon,
                isFavorite: !movie.isFavorite, // Geri al
              );
            }
            return movie;
          }).toList();

      emit(state.copyWith(movies: revertedMovies, error: 'Favori güncelleme hatası'));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
