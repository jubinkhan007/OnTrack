import 'package:flutter/material.dart';

class Palette {
  static const Color scaffold = Color(0xFFF0F2F5);

  static const Color mainColor = Color(0xFFE10101);
  static const Color tabColor = Color(0xFFE25C1A);

  static const Color grayColor = Color(0xFF808080);
  static const Color navyBlueColor = Color(0xFF001F3F);
  static const Color goldColor = Color(0xFFFFD700);
  static const Color tealColor = Color(0xFF008080);

  static const Color delayedCardColor = Color(0xFFFF3D3D);
  static const Color pendingCardColor = Color(0xFFEDA7FF);
  static const Color completedCardColor = Color(0xFF5CD669);


/*Crimson: #DC143C
Fire Engine Red: #CE2029
Cherry Red: #FF3D3D*/

  static const Color semiTv = Color(0xFF2F3232);
  static const Color normalTv = Color(0xFF040404);
  static const Color semiNormalTv = Color(0xFF6E7591);
  static const Color circleColor = Color(0xFFCCCCCC);
  static const Color iconColor = Color(0xFFDF0201);
  static const Color errorColor = Color(0xFFB3261E);
  static const Color cardColor = Color(0xFFF0F2F8);

  static const LinearGradient createRoomGradient = LinearGradient(
    colors: [mainColor, tabColor],
  );

  static const Color online = Color(0xFF4BCB1F);

  static const LinearGradient storyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black26],
  );
}
