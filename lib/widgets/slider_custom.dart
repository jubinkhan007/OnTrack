import 'package:flutter/material.dart';

class CustomSliderTrackShape extends SliderTrackShape {
  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required Animation<double> enableAnimation,
        bool isDiscrete = false,
        bool isEnabled = false,
        required RenderBox parentBox,
        Offset? secondaryOffset,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required Offset thumbCenter,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activePaint = Paint()..color = Colors.green;
    final Paint inactivePaint = Paint()..color = Colors.white;

    final Rect activeTrackSegment = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    final Rect inactiveTrackSegment = Rect.fromLTRB(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
    );

    context.canvas.drawRect(activeTrackSegment, activePaint);
    context.canvas.drawRect(inactiveTrackSegment, inactivePaint);
  }

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset.dx + 8.0;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 16.0;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
