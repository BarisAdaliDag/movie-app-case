import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  _buildWelcomeSection(state),

                  const SizedBox(height: 32),

                  // Featured Movies Section
                  _buildFeaturedMoviesSection(),

                  const SizedBox(height: 32),

                  // Categories Section
                  _buildCategoriesSection(),

                  const SizedBox(height: 32),

                  // Quick Actions Section
                  _buildQuickActionsSection(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(AuthState state) {
    final userName = state.user?.name ?? 'Kullanıcı';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white20Opacity, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hoşgeldin,', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(userName, style: AppTextStyles.headline2.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Text(
            'Bugün hangi filmi izleyeceksin?',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedMoviesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Öne Çıkan Filmler', style: AppTextStyles.headline3),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.white20Opacity, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie, size: 48, color: AppColors.primaryColor),
                    const SizedBox(height: 8),
                    Text('Film ${index + 1}', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('Yakında', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'name': 'Aksiyon', 'icon': Icons.local_fire_department},
      {'name': 'Komedi', 'icon': Icons.emoji_emotions},
      {'name': 'Drama', 'icon': Icons.theater_comedy},
      {'name': 'Korku', 'icon': Icons.nights_stay},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kategoriler', style: AppTextStyles.headline3),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.white20Opacity, width: 1),
              ),
              child: Row(
                children: [
                  Icon(category['icon'] as IconData, color: AppColors.primaryColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(child: Text(category['name'] as String, style: AppTextStyles.bodyMedium)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hızlı İşlemler', style: AppTextStyles.headline3),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Favoriler (Yakında)',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bu özellik yakında eklenecek!'), backgroundColor: AppColors.primaryColor),
            );
          },
          backgroundColor: AppColors.secondaryColor,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'İzleme Geçmişi (Yakında)',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bu özellik yakında eklenecek!'), backgroundColor: AppColors.primaryColor),
            );
          },
          backgroundColor: AppColors.secondaryColor,
        ),
      ],
    );
  }
}
