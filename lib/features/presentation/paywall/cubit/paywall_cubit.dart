import 'package:flutter_bloc/flutter_bloc.dart';
import 'paywall_state.dart';

class PaywallCubit extends Cubit<PaywallState> {
  PaywallCubit() : super(const PaywallState());

  /// Paket seçimini güncelle
  void selectPackage(int index) {
    emit(state.copyWith(selectedPackageIndex: index));
  }

  /// Seçili paketin bilgilerini al
  Map<String, String> getSelectedPackageInfo() {
    switch (state.selectedPackageIndex) {
      case 0:
        return {'discountPercentage': '10%', 'originaljetons': '200', 'currentjetons': '330', 'price': '99.99'};
      case 1:
        return {'discountPercentage': '70%', 'originaljetons': '2000', 'currentjetons': '3375', 'price': '799.99'};
      case 2:
        return {'discountPercentage': '35%', 'originaljetons': '1000', 'currentjetons': '1350', 'price': '399.99'};
      default:
        return {'discountPercentage': '70%', 'originaljetons': '2000', 'currentjetons': '3375', 'price': '799.99'};
    }
  }
}
