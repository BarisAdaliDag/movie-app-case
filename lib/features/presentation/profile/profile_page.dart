import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/getIt/get_it.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/routes/routes.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/custom_app_bar.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';
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
import 'package:responsive_sizer/responsive_sizer.dart';

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
    // showDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   barrierColor: Colors.black.withValues(alpha: 0.7),
    //   builder: (context) => const LimitedOfferPopup(),
    // );
    showCustomBottomSheet(context: context, child: PaywallPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(
        title: "Profil Detayı",
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
            return const LoadingWidget(message: 'Loading profile...');
          }

          if (!authState.isAuthenticated) {
            Future.microtask(() => Navigation.pushReplacementNamed(root: Routes.login));
            return Container();
          }

          if (authState.user == null) {
            return Center(
              child: Text(
                'No user data available',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
              ),
            );
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
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      ProfileHeaderWidget(user: authState.user!),

                      const SizedBox(height: 32),

                      // Favorite Movies Section
                      ProfileMoviesGridWidget(profileState: profileState),

                      const SizedBox(height: 32),

                      // Logout Button
                      const ProfileLogoutButton(),

                      const SizedBox(height: 24),
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

void showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder:
        (context) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 100),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            child: CustomBottomSheet(child: child),
          ),
        ),
  );
}
