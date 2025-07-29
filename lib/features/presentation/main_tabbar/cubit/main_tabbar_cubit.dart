import 'package:flutter_bloc/flutter_bloc.dart';

class MainTabbarState {
  final int currentIndex;

  const MainTabbarState({this.currentIndex = 0});

  MainTabbarState copyWith({int? currentIndex}) {
    return MainTabbarState(currentIndex: currentIndex ?? this.currentIndex);
  }
}

class MainTabbarCubit extends Cubit<MainTabbarState> {
  MainTabbarCubit({int initialIndex = 0}) : super(MainTabbarState(currentIndex: initialIndex));

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
