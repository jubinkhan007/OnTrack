import 'package:flutter/material.dart';
import 'package:tmbi/models/home_flag.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../config/palette.dart';

class FeatureStatus extends StatelessWidget {
  final List<HomeFlag> homeFlags;

  const FeatureStatus({super.key, required this.homeFlags});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Converts.c48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        scrollDirection: Axis.horizontal,
        itemCount: homeFlags.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              color: homeFlags[index].isSelected ? Palette.mainColor : Palette.mainColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            padding:
                const EdgeInsets.only(left: 8, right: 16, top: 2, bottom: 2),
            //color: Colors.green,
            margin: const EdgeInsets.only(left: 8),
            child: Center(
              child: TextViewCustom(
                  text: homeFlags[index].title,
                  fontSize: Converts.c16,
                  tvColor: homeFlags[index].isSelected ? Colors.white : Palette.mainColor.withOpacity(0.8),
                  isBold: false),
            ),
          );
        },
      ),
    );
  }
}
