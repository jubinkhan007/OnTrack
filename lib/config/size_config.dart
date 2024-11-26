import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;

  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;

  /*void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
    //debugPrint('$_screenWidth $_screenHeight');
    _blockWidth = _screenWidth / 50.5854791898;
    _blockHeight = _screenHeight / 112.4121759774;
    //log('$_blockWidth $_blockHeight');
    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
  }*/

  void init2(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData!.size.width; // 360
    _screenHeight = _mediaQueryData!.size.height; // 752
    //_screenWidth = screenSize.width;
    //_screenHeight = screenSize.height;

    _blockWidth = _screenWidth / 50.5854791898;
    _blockHeight = _screenHeight / 112.4121759774;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
  }

}
