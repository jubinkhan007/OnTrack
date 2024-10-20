import 'package:flutter/material.dart';

class Palette {
  static const Color scaffold = Color(0xFFF0F2F5);

  static const Color mainColor = Color(0xFF613BE7);

  static const Color semiTv = Color(0xFF93989D);
  static const Color normalTv = Color(0xFF112022);
  static const Color semiNormalTv = Color(0xFF6E7591);
  static const Color circleColor = Color(0xFFCCCCCC);
  static const Color iconColor = Color(0xFF444444);
  static const Color errorColor = Color(0xFFB3261E);
  static const Color cardColor = Color(0xFFF0F2F8);

  static const LinearGradient createRoomGradient = LinearGradient(
    colors: [Color(0xFF496AE1), Color(0xFFCE48B1)],
  );

  static const Color online = Color(0xFF4BCB1F);

  static const LinearGradient storyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black26],
  );
}
