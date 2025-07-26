import 'package:equatable/equatable.dart';

class PaywallState extends Equatable {
  final int selectedPackageIndex;

  const PaywallState({
    this.selectedPackageIndex = 1, // Default to middle package (index 1)
  });

  PaywallState copyWith({int? selectedPackageIndex}) {
    return PaywallState(selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex);
  }

  @override
  List<Object?> get props => [selectedPackageIndex];
}
