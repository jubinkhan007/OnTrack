import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../config/strings.dart';

class SwitchContainer extends StatefulWidget {
  final Function(bool) onSwitchTap;

  const SwitchContainer({super.key, required this.onSwitchTap});

  @override
  State<SwitchContainer> createState() => _SwitchContainerState();
}

class _SwitchContainerState extends State<SwitchContainer> {
  bool _isAssignedTaped = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isAssignedTaped = !_isAssignedTaped;
              widget.onSwitchTap(_isAssignedTaped);
            });
          },
          child: Container(
            padding: EdgeInsets.only(left: Converts.c8, right: Converts.c8),
            height: 28,
            decoration: BoxDecoration(
              color: _isAssignedTaped ? Colors.deepOrange : Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Converts.c16),
                bottomLeft: Radius.circular(Converts.c16),
              ), // Rounded corners
            ),
            child: Center(
              child: TextViewCustom(
                text: Strings.assigned,
                fontSize: Converts.c12,
                tvColor: _isAssignedTaped ? Colors.white : Palette.normalTv,
                isRubik: _isAssignedTaped ? true : false,
                isBold: _isAssignedTaped ? true : false,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isAssignedTaped = !_isAssignedTaped;
              widget.onSwitchTap(_isAssignedTaped);
            });
          },
          child: Container(
            padding: EdgeInsets.only(left: Converts.c8, right: Converts.c8),
            height: 28,
            decoration: BoxDecoration(
              color: _isAssignedTaped ? Colors.grey : Colors.deepOrange,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Converts.c16),
                  bottomRight:
                      Radius.circular(Converts.c16)), // Rounded corners
            ),
            child: Center(
              child: TextViewCustom(
                text: Strings.created,
                fontSize: Converts.c12,
                tvColor: _isAssignedTaped ? Palette.normalTv : Colors.white,
                isBold: _isAssignedTaped ? false : true,
                isRubik: _isAssignedTaped ? false : true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
