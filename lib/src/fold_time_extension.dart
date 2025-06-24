extension FoldTimeExtension on double {
  S foldZero<S>(S Function(double) onNegative, S Function(double) onPositive) =>
      this < 0.0 ? onNegative(this) : onPositive(this);

  S foldPredicate<S>(
    bool Function(double) predicate,
    S Function(double) onTrue,
    S Function(double) onFalse,
  ) => predicate(this) ? onTrue(this) : onFalse(this);

  S foldRange<S>({
    required (double, double) bounds,
    required S Function(double) inRange,
    required S Function(double) outOfRange,
  }) {
    return (this >= bounds.$1 && this <= bounds.$2) ? inRange(this) : outOfRange(this);
  }
}
