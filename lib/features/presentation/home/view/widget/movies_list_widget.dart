import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/presentation/home/cubit/home_cubit.dart';
import 'package:movieapp/features/presentation/home/cubit/home_state.dart';
import 'package:movieapp/features/presentation/home/view/widget/movie_card.dart';

class MoviesListWidget extends StatelessWidget {
  final PageController pageController;
  final HomeState state;

  const MoviesListWidget({super.key, required this.pageController, required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().refreshMovies(),
      color: Colors.red,
      backgroundColor: Colors.grey[900],
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: pageController,
        itemCount: state.movies.length + (state.canLoadMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Loading indicator için son item
          if (index >= state.movies.length) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }

          final movie = state.movies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: MovieCard(movie: movie, onFavoriteToggle: () => context.read<HomeCubit>().toggleFavorite(movie.id)),
          );
        },
      ),
    );
  }
}
