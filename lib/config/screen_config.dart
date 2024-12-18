import 'package:flutter/material.dart';

class ScreenConfig {

  ScreenConfig._privateConstructor();

  static final ScreenConfig? _instance = ScreenConfig._privateConstructor();

  factory ScreenConfig() {
    if (_instance == null) {
      return ScreenConfig._privateConstructor();
    }
    return _instance!;
  }

  // device screen properties
  double screenWidth = 0;
  double screenHeight = 0;
  double blockWidth = 0;
  double blockHeight = 0;
  double textScaleFactor = 1.0;

  // scaling multipliers
  double textMultiplier = 0;
  double imageSizeMultiplier = 0;
  double heightMultiplier = 0;
  double widthMultiplier = 0;

  // initialization function (call once at the start of the app)
  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width; // 360
    screenHeight = MediaQuery.of(context).size.height; // 752

    blockWidth = screenWidth / 50.5854791898;
    blockHeight = screenHeight / 112.4121759774;

    textMultiplier = blockHeight;
    imageSizeMultiplier = blockWidth;
    heightMultiplier = blockHeight;
    widthMultiplier = blockWidth;
  }

  // get dynamic font size
  double getSize(double baseSize) {
    return baseSize * textMultiplier /** textScaleFactor*/;
  }

  // get dynamic image size
  double getImageSize(double baseSize) {
    return baseSize * imageSizeMultiplier;
  }

}