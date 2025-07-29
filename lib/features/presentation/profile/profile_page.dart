import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/core/getIt/get_it.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/widgets/custom_app_bar.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/core/widgets/loading_widget.dart';
import 'package:movieapp/features/presentation/paywall/widget/custom_bottom_sheet.dart';
import 'package:movieapp/features/presentation/paywall/paywall_page.dart';
import 'package:movieapp/features/presentation/profile/cubit/profile_cubit.dart';
import 'package:movieapp/features/presentation/profile/cubit/profile_state.dart';
import 'package:movieapp/features/presentation/profile/widget/limited_offer_badge.dart';
import 'package:movieapp/features/presentation/profile/widget/profile_header_widget.dart';
import 'package:movieapp/features/presentation/profile/widget/profile_movies_grid_widget.dart';
import 'package:movieapp/features/presentation/profile/widget/profile_logout_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..loadFavoriteMovies(),
      child: const _ProfilePageContent(),
    );
  }
}

class _ProfilePageContent extends StatelessWidget {
  const _ProfilePageContent();

  void showLimitedOfferPopup(BuildContext context) {
    _showCustomBottomSheet(context: context, child: PaywallPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(
        title: AppConstants.profileDetails,
        showBackButton: false,
        actions: [
          LimitedOfferBadge(
            onTap: () {
              showLimitedOfferPopup(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState.isLoading) {
            return const LoadingWidget(message: AppConstants.loading);
          }

          if (authState.user == null) {
            return const Center(child: Text('Kullanıcı bilgileri yüklenemedi'));
          }

          return BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, profileState) {
              if (profileState.hasError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(profileState.error!), backgroundColor: AppColors.error));
                context.read<ProfileCubit>().clearError();
              }
            },
            builder: (context, profileState) {
              final user = authState.user;
              if (user == null) {
                return const Center(child: Text('Kullanıcı bilgileri yüklenemedi'));
              }

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Header
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileHeaderWidget(user: user),
                          const SizedBox(height: 32),

                          // Favorite Movies Section
                          ProfileMoviesGridWidget(profileState: profileState),

                          const SizedBox(height: 32),
                        ],
                      ),

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const ProfileLogoutButton()]),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void _showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    // barrierColor: Colors.black.withValues(alpha: 0.5),
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder:
        (context) => GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {}, // Bottom sheet içeriğine tıklanınca kapanmasını engeller
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 100),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  child: CustomBottomSheet(child: child),
                ),
              ),
            ),
          ),
        ),
  );
}
