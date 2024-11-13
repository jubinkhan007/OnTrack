import 'package:flutter/cupertino.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../config/palette.dart';

class ErrorContainer extends StatelessWidget {
  final String message;

  const ErrorContainer({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/ic_empty_2.png',
          height: Converts.c120,
          width: Converts.c120,
        ),
        TextViewCustom(
            text: message,
            fontSize: Converts.c16,
            tvColor: Palette.semiTv,
            isBold: false)
      ],
    );
  }
}
