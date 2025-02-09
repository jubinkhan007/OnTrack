import 'package:flutter/material.dart';
import 'package:tmbi/models/home_flag.dart';
import 'package:tmbi/screens/home_screen.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../config/enum.dart';
import '../config/palette.dart';

class FeatureStatus extends StatelessWidget {
  final List<HomeFlag> homeFlags;
  final Function(String, StatusFlag) onPressed;
  final int selectedFlagIndex;

  const FeatureStatus({
    super.key,
    required this.homeFlags,
    required this.onPressed,
    required this.selectedFlagIndex, // Include selected index in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blueAccent,
      height: Converts.c48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        scrollDirection: Axis.horizontal,
        itemCount: homeFlags.length,
        itemBuilder: (BuildContext context, int index) {
          bool isSelected =
              index == selectedFlagIndex; // Use parent-provided selection

          return GestureDetector(
            onTap: () {
              onPressed(homeFlags[index].title, homeFlags[index].status);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Palette.tabColor
                    : Palette.tabColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : Palette.tabColor.withOpacity(0.8),
                ),
              ),
              padding:
                  const EdgeInsets.only(left: 8, right: 16, top: 2, bottom: 2),
              margin: const EdgeInsets.only(left: 8),
              child: Center(
                child: TextViewCustom(
                  text: homeFlags[index].title,
                  fontSize: Converts.c16,
                  tvColor: isSelected ? Colors.white : Colors.black,
                  isRubik: false,
                  isBold: isSelected,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
