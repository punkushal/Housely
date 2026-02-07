class Onboarding {
  final String imagePath;
  final String firstHeading;
  final String boldContent;
  final String? lastHeading;
  final String subtitleInfo;

  Onboarding({
    required this.imagePath,
    required this.firstHeading,
    required this.boldContent,
    this.lastHeading,
    required this.subtitleInfo,
  });
}
