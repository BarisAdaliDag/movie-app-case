// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/getIt/get_it.dart';

import 'package:movieapp/features/presentation/home/cubit/home_cubit.dart';
import 'package:movieapp/features/presentation/home/cubit/home_state.dart';
import 'package:movieapp/features/presentation/home/view/widget/home_loading_widget.dart';
import 'package:movieapp/features/presentation/home/view/widget/home_error_widget.dart';
import 'package:movieapp/features/presentation/home/view/widget/home_empty_widget.dart';
import 'package:movieapp/features/presentation/home/view/widget/movies_list_widget.dart';
import 'package:movieapp/features/presentation/home/view/widget/loading_more_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.loadPage = true});
  final bool? loadPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = getIt<HomeCubit>().state.currentPageIndex;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(_onPageChanged);
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
          return _buildContent(context, state);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    // Initial loading
    if (state.isInitial || (state.isLoading && state.movies.isEmpty)) {
      return const HomeLoadingWidget();
    }

    // Error state with no movies
    if (state.hasError && state.movies.isEmpty) {
      return HomeErrorWidget(error: state.error!);
    }

    // Empty state
    if (state.isEmpty) {
      return const HomeEmptyWidget();
    }

    // Movies list
    return Stack(
      children: [
        MoviesListWidget(pageController: _pageController, state: state),
        if (state.isLoadingMore) const LoadingMoreIndicator(),
      ],
    );
  }
}
