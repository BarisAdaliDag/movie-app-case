import 'package:equatable/equatable.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';

class ProfileState extends Equatable {
  final List<MovieModel> favoriteMovies;
  final bool isLoading;
  final String? error;

  const ProfileState({this.favoriteMovies = const [], this.isLoading = false, this.error});

  ProfileState copyWith({List<MovieModel>? favoriteMovies, bool? isLoading, String? error}) {
    return ProfileState(
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // Helper getters
  bool get hasError => error != null;
  bool get hasFavorites => favoriteMovies.isNotEmpty;
  bool get isEmpty => favoriteMovies.isEmpty && !isLoading;

  @override
  List<Object?> get props => [favoriteMovies, isLoading, error];
}
