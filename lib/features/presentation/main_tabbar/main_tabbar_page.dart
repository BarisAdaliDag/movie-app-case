import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/home/view/home_page.dart';
import 'package:movieapp/features/presentation/home/cubit/home_cubit.dart';
import 'package:movieapp/features/presentation/main_tabbar/cubit/main_tabbar_cubit.dart';
import 'package:movieapp/features/presentation/main_tabbar/widget/custom_button_navigation.dart';
import 'package:movieapp/features/presentation/profile/profile_page.dart';

class MainTabbarPage extends StatelessWidget {
  const MainTabbarPage({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainTabbarCubit(initialIndex: initialIndex),
      child: const _MainTabbarPageContent(),
    );
  }
}

class _MainTabbarPageContent extends StatefulWidget {
  const _MainTabbarPageContent();

  @override
  State<_MainTabbarPageContent> createState() => _MainTabbarPageContentState();
}

class _MainTabbarPageContentState extends State<_MainTabbarPageContent> {
  late PageController _pageController;
  final List<Widget> _pages = [const HomePage(loadPage: false), const ProfilePage()];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MainTabbarCubit>();
    _pageController = PageController(initialPage: cubit.state.currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    context.read<MainTabbarCubit>().changeTab(index);

    if (index == 0) {
      final homeCubit = context.read<HomeCubit>();
      if (homeCubit.state.movies.isEmpty && !homeCubit.state.isLoading) {
        homeCubit.loadMovies();
      }
    }
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);

    if (index == 0) {
      final homeCubit = context.read<HomeCubit>();
      if (homeCubit.state.movies.isEmpty && !homeCubit.state.isLoading) {
        homeCubit.loadMovies();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // If user logs out, this will be handled by the main routing logic
      },
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<MainTabbarCubit, MainTabbarState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Expanded(
                    child: PageView(controller: _pageController, onPageChanged: _onPageChanged, children: _pages),
                  ),
                  CustomBottomNavigation(currentIndex: state.currentIndex, onTap: _onTabTapped),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
