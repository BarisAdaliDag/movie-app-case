import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/home/view/home_page.dart';
import 'package:movieapp/features/presentation/home/cubit/home_cubit.dart';
import 'package:movieapp/features/presentation/main_tabbar/widget/custom_button_navigation.dart';
import 'package:movieapp/features/presentation/profile/profile_page.dart';

class MainTabbarPage extends StatefulWidget {
  const MainTabbarPage({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainTabbarPage> createState() => _MainTabbarPageState();
}

class _MainTabbarPageState extends State<MainTabbarPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [const HomePage(loadPage: false), const ProfilePage()];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (index == 0) {
      context.read<HomeCubit>().loadMovies();
    }
    setState(() {
      _currentIndex = index;
    });

    // Eğer home sayfasına (index 0) geçiş yapıldıysa ve movies boşsa yükle
    if (index == 0) {
      final homeCubit = context.read<HomeCubit>();
      if (homeCubit.state.movies.isEmpty && !homeCubit.state.isLoading) {
        homeCubit.loadMovies();
      }
    }
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);

    // Eğer home sayfasına (index 0) geçiş yapıldıysa ve movies boşsa yükle
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(child: PageView(controller: _pageController, onPageChanged: _onPageChanged, children: _pages)),
              CustomBottomNavigation(currentIndex: _currentIndex, onTap: _onTabTapped),
            ],
          ),
          // bottomNavigationBar: CustomBottomNavigation(currentIndex: _currentIndex, onTap: _onTabTapped),
        ),
      ),
    );
  }
}
