class RatingUtils {
  static double _round(double val, [int precision = 1]) =>
      double.parse(val.toStringAsFixed(precision));

  static double computeNewAverageOnAdd({
    required double currentAvg,
    required int totalReviews,
    required double newRating,
    int precision = 1,
  }) {
    final double oldTotal = currentAvg * totalReviews;
    final int newTotalReviews = totalReviews + 1;
    final double newAvg = (oldTotal + newRating) / newTotalReviews;
    return _round(newAvg, precision).clamp(0.0, 5.0);
  }

  static double computeNewAverageOnUpdate({
    required double currentAvg,
    required int totalReviews,
    required double oldRating,
    required double newRating,
    int precision = 1,
  }) {
    if (totalReviews <= 0) return _round(newRating, precision).clamp(0.0, 5.0);

    final double newAvg =
        ((currentAvg * totalReviews) - oldRating + newRating) / totalReviews;
    return _round(newAvg, precision).clamp(0.0, 5.0);
  }

  static double computeNewAverageOnDelete({
    required double currentAvg,
    required int totalReviews,
    required double ratingToDelete,
    int precision = 1,
  }) {
    final int newCount = totalReviews - 1;
    if (newCount > 0) {
      final double newAvg =
          ((currentAvg * totalReviews) - ratingToDelete) / newCount;
      return _round(newAvg, precision).clamp(0.0, 5.0);
    }

    return 0.0;
  }
}
