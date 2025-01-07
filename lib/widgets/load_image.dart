import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/converts.dart';
import '../config/palette.dart';

class LoadImage extends StatelessWidget {
  final String id;
  final double height;
  final double width;

  const LoadImage(
      {super.key, required this.id, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: height,
        height: width,
        child: CachedNetworkImage(
          imageUrl:
              "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/$id/$id-0.jpg",
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: Converts.c16,
            height: Converts.c16,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Palette.mainColor),
              strokeWidth: 2.0,
            ),
          ),
          errorWidget: (context, url, error) {
            return Icon(
              Icons.account_circle,
              color: Palette.normalTv,
              size: Converts.c48,
            );
          },
        ),
      ),
    );
  }
}
