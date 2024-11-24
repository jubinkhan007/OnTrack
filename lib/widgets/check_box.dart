import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

class CheckBox extends StatefulWidget {
  final String title;
  final bool isTitleBold;
  final bool isChecked; // test
  final Function(String?) onChecked;

  const CheckBox(
      {super.key,
      required this.onChecked,
      required this.title,
      required this.isTitleBold,
      required this.isChecked}); // test

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  /// `didUpdateWidget`: This method is called whenever the parent widget
  /// passes a new value for `isChecked`. By comparing `oldWidget.isChecked`
  /// with `widget.isChecked`, we can update `_isChecked` to ensure the checkbox
  /// reflects the latest value.
  @override
  void didUpdateWidget(CheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      // synchronize the local state with the parent's state
      _isChecked = widget.isChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value!;
                  widget.onChecked(_isChecked ? "Y" : "N");
                });
              }),
        ),
        TextViewCustom(
          text: widget.title,
          fontSize: Converts.c16,
          tvColor: Palette.normalTv,
          isBold: widget.isTitleBold,
          isRubik: false,
        ),
      ],
    );
  }
}
