import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/features/onboarding/domain/entities/onboarding.dart';

/// Onboarding pages data list
final List<Onboarding> pages = [
  Onboarding(
    imagePath: ImageConstant.firstOnBoardingImg,
    firstHeading: "Find the ",
    boldContent: "perfect place ",
    lastHeading: "for your future house",
    subtitleInfo:
        "find the best place for your dream house with your family and loved ones",
  ),
  Onboarding(
    imagePath: ImageConstant.secondOnBoardingImg,
    firstHeading: "Fast sell your property in just",
    boldContent: " one click",
    subtitleInfo:
        "Simplify the property sales process with just your smartphone",
  ),

  Onboarding(
    imagePath: ImageConstant.thirdOnBoardingImg,
    firstHeading: "find your ",
    boldContent: "dream home\n",
    lastHeading: "with us",
    subtitleInfo:
        "Just search and select your favorite property you want to locate",
  ),
];
