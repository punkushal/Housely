import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/features/home/data/models/nav_item.dart';

final List<NavItem> navList = [
  NavItem(
    iconPath: ImageConstant.homeIcon,
    iconFilledPath: ImageConstant.homeFilledIcon,
    label: TextConstants.home,
  ),
  NavItem(
    iconPath: ImageConstant.discoveryIcon,
    iconFilledPath: ImageConstant.discoveryFilledIcon,
    label: TextConstants.explore,
  ),
  NavItem(
    iconPath: ImageConstant.documentIcon,
    iconFilledPath: ImageConstant.documentFilledIcon,
    label: TextConstants.booking,
  ),
  NavItem(
    iconPath: ImageConstant.personIcon,
    iconFilledPath: ImageConstant.personFilledIcon,
    label: TextConstants.profile,
  ),
];
