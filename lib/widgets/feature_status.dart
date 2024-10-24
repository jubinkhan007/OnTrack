import 'package:flutter/material.dart';
import 'package:tmbi/models/home_flag.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../config/palette.dart';

class FeatureStatus extends StatefulWidget {
  final List<HomeFlag> homeFlags;
  final Function(String) onPressed;

  const FeatureStatus({
    super.key,
    required this.homeFlags,
    required this.onPressed,
  });

  @override
  State<FeatureStatus> createState() => _FeatureStatusState();
}

class _FeatureStatusState extends State<FeatureStatus> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Converts.c48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        scrollDirection: Axis.horizontal,
        itemCount: widget.homeFlags.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              widget.onPressed(widget.homeFlags[index].title);
              setState(() {
                for (int i = 0; i < widget.homeFlags.length; i++) {
                  if (i == index) {
                    widget.homeFlags[index].isSelected = true;
                  } else {
                    widget.homeFlags[i].isSelected = false;
                  }
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: widget.homeFlags[index].isSelected
                      ? Palette.tabColor
                      : Palette.tabColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: widget.homeFlags[index].isSelected
                          ? Colors.white
                          : Palette.tabColor.withOpacity(0.8))),
              padding:
                  const EdgeInsets.only(left: 8, right: 16, top: 2, bottom: 2),
              //color: Colors.green,
              margin: const EdgeInsets.only(left: 8),
              child: Center(
                child: TextViewCustom(
                    text: widget.homeFlags[index].title,
                    fontSize: Converts.c16,
                    tvColor: widget.homeFlags[index].isSelected
                        ? Colors.white
                        : Colors.black,
                    isRubik: false,
                    isBold: widget.homeFlags[index].isSelected ? true : false),
              ),
            ),
          );
        },
      ),
    );
  }

}
