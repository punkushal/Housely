class NavItem {
  final String iconPath;
  final String iconFilledPath;
  final String label;
  final bool isActive;

  NavItem({
    required this.iconPath,
    required this.iconFilledPath,
    required this.label,
    this.isActive = false,
  });
}
