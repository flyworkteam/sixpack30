class OnboardViewModel {
  final int currentIndex;
  OnboardViewModel({this.currentIndex = 0});
  OnboardViewModel copyWith({
    int? currentIndex,
  }) {
    return OnboardViewModel(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
