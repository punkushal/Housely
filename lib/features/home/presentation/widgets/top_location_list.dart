import 'package:flutter/material.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/widgets/top_location_card.dart';

class TopLocationList extends StatefulWidget {
  const TopLocationList({super.key});

  @override
  State<TopLocationList> createState() => _TopLocationListState();
}

class _TopLocationListState extends State<TopLocationList> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveDimensions.getHeight(context, 45),
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: ResponsiveDimensions.paddingOnly(context, right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
              },
              child: TopLocationCard(
                location: "Pokhara",
                isActive: _currentIndex == index,
              ),
            ),
          );
        },
      ),
    );
  }
}
