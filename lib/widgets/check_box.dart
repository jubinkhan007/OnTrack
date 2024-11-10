import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

class CheckBox extends StatefulWidget {
  final Function(String?) onChecked;

  const CheckBox({super.key, required this.onChecked});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
                widget.onChecked(_isChecked ? "Y" : "N");
              });
            }),
        TextViewCustom(
          text: Strings.is_sample,
          fontSize: Converts.c16,
          tvColor: Palette.normalTv,
          isBold: true,
          isRubik: false,
        ),
      ],
    );
  }
}
