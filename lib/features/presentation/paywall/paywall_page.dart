import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/core/getIt/get_it.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:movieapp/features/presentation/paywall/cubit/paywall_cubit.dart';
import 'package:movieapp/features/presentation/paywall/cubit/paywall_state.dart';
import 'package:movieapp/features/presentation/paywall/widget/bonus_features_card.dart';
import 'package:movieapp/features/presentation/paywall/widget/paywall_selection_container.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    // GetIt'ten direkt cubit instance'ı al
    final paywallCubit = getIt<PaywallCubit>();

    return BlocBuilder<PaywallCubit, PaywallState>(
      bloc: paywallCubit, // Bloc parametresi ekle
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 75.h,
            width: 100.w,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppConstants.limitedOffer, style: AppTextStyles.headline3.copyWith(fontSize: 20)),

                  const SizedBox(height: 4),

                  Text(
                    AppConstants.jetonPaketiAciklama,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyRegular.copyWith(),
                  ),

                  const SizedBox(height: 12),

                  BonusFeaturesCard(),
                  Gap(20),
                  Text(
                    AppConstants.unlockDescription,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bottomTabBarStyle.copyWith(),
                  ),
                  Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PaywallSelectionContainer(
                        index: 0,
                        discountPercentage: '10%',
                        originaljetons: '200',
                        currentjetons: '330',
                        price: '99.99',
                        isSelected: state.selectedPackageIndex == 0,
                        onTap: () => paywallCubit.selectPackage(0), // Direkt cubit kullan
                      ),
                      PaywallSelectionContainer(
                        index: 1,
                        discountPercentage: '70%',
                        originaljetons: '2000',
                        currentjetons: '3375',
                        price: '799.99',
                        isSelected: state.selectedPackageIndex == 1,
                        onTap: () => paywallCubit.selectPackage(1), // Direkt cubit kullan
                      ),
                      PaywallSelectionContainer(
                        index: 2,
                        discountPercentage: '35%',
                        originaljetons: '1000',
                        currentjetons: '1350',
                        price: '399.99',
                        isSelected: state.selectedPackageIndex == 2,
                        onTap: () => paywallCubit.selectPackage(2), // Direkt cubit kullan
                      ),
                    ],
                  ),

                  Gap(20),
                  CustomButton(
                    text: AppConstants.seeAllTokens,
                    onPressed: () {
                      //    Navigation.ofPop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
