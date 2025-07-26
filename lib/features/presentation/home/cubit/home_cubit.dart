import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/utils/secure_storage.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/data/repositories/movie/movie_repository.dart';
import 'package:movieapp/features/presentation/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MovieRepository movieRepository;
  final Random _random = Random();

  HomeCubit({required this.movieRepository}) : super(const HomeState());

  // Rastgele sayfa numaraları listesi oluştur
  List<int> _generateRandomPageNumbers(int maxPage) {
    final pages = List.generate(maxPage, (index) => index + 1);
    pages.shuffle(_random); // Listeyi karıştır
    return pages;
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  Future<void> loadMovies({bool isRefresh = false}) async {
    try {
      emit(state.copyWith(isLoading: true));
      final token = await SecureStorage.getToken();
      if (token == null) {
        emit(state.copyWith(error: 'Token bulunamadı', isLoading: false, isRefreshing: false, isInitial: false));
        return;
      }

      if (isRefresh) {
        emit(state.copyWith(isRefreshing: true, error: null, isLoading: true));
      } else {
        emit(state.copyWith(isLoading: true, error: null, isInitial: false));
      }

      // İlk önce maxPage'i öğrenmek için sayfa 1'i yükle
      final firstResponse = await movieRepository.getMovies(token: token, page: 1);
      final maxPage = firstResponse.pagination.maxPage;

      // Rastgele sayfa numaraları listesi oluştur
      final randomPages = _generateRandomPageNumbers(maxPage);
      print('random pages $randomPages');
      // İlk sayfa numarasını kullanarak filmleri yükle
      final firstPageNumber = randomPages.first;
      final moviesResponse = await movieRepository.getMovies(token: token, page: firstPageNumber);
      print('Loaded movies for page $firstPageNumber: ${moviesResponse.movies.length}');

      emit(
        state.copyWith(
          movies: moviesResponse.movies,
          currentPage: moviesResponse.pagination.currentPage,
          hasReachedMax: randomPages.length <= 1, // Sadece 1 sayfa varsa max'a ulaştık
          isLoading: false,
          isRefreshing: false,
          error: null,
          pagination: moviesResponse.pagination,
          randomPageNumbers: randomPages,
          currentPageIndex: 0, // İlk elemanı kullandık
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

      // Sıradaki sayfa numarasını al
      final nextPageIndex = state.currentPageIndex + 1;
      final nextPageNumber = state.randomPageNumbers[nextPageIndex];

      final moviesResponse = await movieRepository.getMovies(token: token, page: nextPageNumber);
      print('Loaded movies for nextPageNumber page $nextPageNumber: ${moviesResponse.movies.length}');

      // Sadece yeni filmleri ekle, mevcut filmleri koru
      final updatedMovies = [...state.movies, ...moviesResponse.movies];

      emit(
        state.copyWith(
          movies: updatedMovies,
          currentPage: moviesResponse.pagination.currentPage,
          isLoadingMore: false,
          hasReachedMax: nextPageIndex >= state.randomPageNumbers.length - 1, // Son sayfaya ulaştık mı?
          error: null,
          currentPageIndex: nextPageIndex,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: 'Daha fazla film yüklenirken hata oluştu'));
    }
  }

  Future<void> refreshMovies() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        emit(state.copyWith(error: 'Token bulunamadı', isRefreshing: false));
        return;
      }

      emit(state.copyWith(isRefreshing: true, error: null));

      // İlk önce maxPage'i öğrenmek için sayfa 1'i yükle
      final firstResponse = await movieRepository.getMovies(token: token, page: 1);
      final maxPage = firstResponse.pagination.maxPage;

      // Rastgele sayfa numaraları listesi oluştur
      final randomPages = _generateRandomPageNumbers(maxPage);
      print('refresh random pages $randomPages');

      // İlk sayfa numarasını kullanarak filmleri yükle
      final firstPageNumber = randomPages.first;
      final moviesResponse = await movieRepository.getMovies(token: token, page: firstPageNumber);
      print('Refresh loaded movies for page $firstPageNumber: ${moviesResponse.movies.length}');

      emit(
        state.copyWith(
          movies: moviesResponse.movies,
          currentPage: moviesResponse.pagination.currentPage,
          hasReachedMax: randomPages.length <= 1,
          isLoading: false,
          isRefreshing: false,
          error: null,
          pagination: moviesResponse.pagination,
          randomPageNumbers: randomPages,
          currentPageIndex: 0,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false, isRefreshing: false));
    }
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
