import 'package:equatable/equatable.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';

class HomeState extends Equatable {
  final List<MovieModel> movies;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final int currentPage;
  final bool isRefreshing;
  final String? error;
  final bool isInitial;

  const HomeState({
    this.movies = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isRefreshing = false,
    this.error,
    this.isInitial = true,
  });

  HomeState copyWith({
    List<MovieModel>? movies,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    int? currentPage,
    bool? isRefreshing,
    String? error,
    bool? isInitial,
  }) {
    return HomeState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
      isInitial: isInitial ?? this.isInitial,
    );
  }

  // Helper getters
  bool get hasError => error != null;
  bool get hasMovies => movies.isNotEmpty;
  bool get isEmpty => movies.isEmpty && !isLoading && !isInitial;
  bool get canLoadMore => !isLoadingMore && !hasReachedMax && !isLoading;

  @override
  List<Object?> get props => [
    movies,
    isLoading,
    isLoadingMore,
    hasReachedMax,
    currentPage,
    isRefreshing,
    error,
    isInitial,
  ];
}
