import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/text_view_custom.dart';
import 'package:tmbi/widgets/widgets.dart';

class CustomerAddView extends StatelessWidget {
  const CustomerAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _customerView(),
        SizedBox(
          width: Converts.c16,
        ),
        _addButton(),
      ],
    );
  }

  Widget _customerView() {
    return Container(
      padding: EdgeInsets.all(Converts.c8),
      decoration: BoxDecoration(
        color: Palette.tabColor.withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(Converts.c20),
        ),
        border: Border.all(
          color: Palette.tabColor, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_circle,
            color: Palette.semiTv,
            size: Converts.c20,
          ),
          SizedBox(
            width: Converts.c8,
          ),
          TextViewCustom(
              text: "Md. Akash",
              fontSize: Converts.c16,
              tvColor: Palette.semiTv,
              isBold: false),
          SizedBox(
            width: Converts.c8,
          ),
          Icon(
            Icons.close,
            color: Palette.semiTv,
            size: Converts.c20,
          ),
        ],
      ),
    );
  }

  Widget _addButton() {
    return Container(
      width: Converts.c48,
      height: Converts.c48,
      decoration: BoxDecoration(
        color: Palette.tabColor,
        borderRadius: BorderRadius.all(
          Radius.circular(Converts.c24),
        ),
        border: Border.all(
          color: Palette.tabColor, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Icon(
        Icons.add,
        size: Converts.c24,
        color: Colors.white,
      ),
    );
  }
}
