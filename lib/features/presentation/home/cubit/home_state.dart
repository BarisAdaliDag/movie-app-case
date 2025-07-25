import 'package:equatable/equatable.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/data/models/movie/pagination_model.dart';

class HomeState extends Equatable {
  final List<MovieModel> movies;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final int currentPage;
  final bool isRefreshing;
  final String? error;
  final bool isInitial;
  final PaginationModel? pagination;
  final List<int> randomPageNumbers; // Rastgele sayfa numaraları listesi
  final int currentPageIndex; // randomPageNumbers listesindeki mevcut index

  const HomeState({
    this.movies = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isRefreshing = false,
    this.error,
    this.isInitial = true,
    this.pagination,
    this.randomPageNumbers = const [],
    this.currentPageIndex = 0,
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
    PaginationModel? pagination,
    List<int>? randomPageNumbers,
    int? currentPageIndex,
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
      pagination: pagination ?? this.pagination,
      randomPageNumbers: randomPageNumbers ?? this.randomPageNumbers,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }

  // Helper getters
  bool get hasError => error != null;
  bool get hasMovies => movies.isNotEmpty;
  bool get isEmpty => movies.isEmpty && !isLoading && !isInitial;
  bool get canLoadMore =>
      !isLoadingMore &&
      !hasReachedMax &&
      !isLoading &&
      randomPageNumbers.isNotEmpty &&
      currentPageIndex < randomPageNumbers.length - 1;

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
    pagination,
    randomPageNumbers,
    currentPageIndex,
  ];
}
