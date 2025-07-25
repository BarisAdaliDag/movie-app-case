import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/utils/secure_storage.dart';
import 'package:movieapp/features/data/repositories/movie/movie_repository.dart';
import 'package:movieapp/features/presentation/profile/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final MovieRepository movieRepository;

  ProfileCubit({required this.movieRepository}) : super(const ProfileState());

  Future<void> loadFavoriteMovies() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        emit(state.copyWith(error: 'Token bulunamadı', isLoading: false));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));

      final favoriteMovies = await movieRepository.getFavorites(token: token);

      emit(state.copyWith(favoriteMovies: favoriteMovies, isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Favori filmler yüklenirken hata oluştu: ${e.toString()}', isLoading: false));
    }
  }

  Future<void> toggleFavorite(String movieId) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) return;

      // Optimistic update - remove from favorites immediately
      final updatedFavorites = state.favoriteMovies.where((movie) => movie.id != movieId).toList();

      emit(state.copyWith(favoriteMovies: updatedFavorites));

      // API call to remove from favorites
      await movieRepository.addFavorite(token: token, movieId: movieId);
    } catch (e) {
      // Reload favorites if there's an error
      await loadFavoriteMovies();
      emit(state.copyWith(error: 'Favori güncelleme hatası'));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
