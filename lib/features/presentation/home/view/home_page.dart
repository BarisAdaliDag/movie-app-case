// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/home/cubit/home_cubit.dart';
import 'package:movieapp/features/presentation/home/cubit/home_state.dart';
import 'package:movieapp/features/presentation/home/view/widget/movie_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.loadPage = true});
  final bool? loadPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
    if (true) {
      // Eğer loadPage true ise, sayfa yüklendiğinde filmleri yükle
      context.read<HomeCubit>().loadMovies();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final currentPage = _pageController.page?.round() ?? 0;
    if (currentPage != _currentPageIndex) {
      _currentPageIndex = currentPage;

      // Son birkaç sayfaya geldiğinde yeni veri yükle
      final totalPages = context.read<HomeCubit>().state.movies.length;
      if (currentPage >= totalPages - 3) {
        context.read<HomeCubit>().loadMoreMovies();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          // Initial loading
          if (state.isInitial || (state.isLoading && state.movies.isEmpty)) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }

          // Error state with no movies
          if (state.hasError && state.movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Bir hata oluştu',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(state.error!, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().loadMovies(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (state.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Henüz film bulunamadı',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => context.read<HomeCubit>().loadMovies(), child: const Text('Yenile')),
                ],
              ),
            );
          }

          // Movies list
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refreshMovies(),
                color: Colors.red,
                backgroundColor: Colors.grey[900],
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  itemCount: state.movies.length + (state.canLoadMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator için son item
                    if (index >= state.movies.length) {
                      return const Center(child: CircularProgressIndicator(color: Colors.red));
                    }

                    final movie = state.movies[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: MovieCard(
                        movie: movie,
                        onFavoriteToggle: () => context.read<HomeCubit>().toggleFavorite(movie.id),
                      ),
                    );
                  },
                ),
              ),
              // Loading more indicator
              if (state.isLoadingMore)
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Yükleniyor...', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
