import 'package:flutter/material.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/comment_response.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';

class CommentList extends StatelessWidget {
  final Comments comments;

  const CommentList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // This will prevent the Row from taking full width
      children: [
        Icon(
          Icons.account_circle,
          color: Palette.normalTv,
          size: Converts.c48,
        ),
        SizedBox(width: Converts.c8),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Converts.c272),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Converts.c8), // Rounded corners
            ),
            elevation: 1, // Shadow effect
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(Converts.c8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewCustom(
                    text: comments.owner!.name!,
                    fontSize: Converts.c16,
                    tvColor: Palette.mainColor,
                    isTextAlignCenter: false,
                    isRubik: false,
                    isBold: true,
                  ),
                  Row(
                    children: [
                      TextViewCustom(
                        text: comments.date!,
                        fontSize: Converts.c12,
                        tvColor: Palette.semiTv,
                        isTextAlignCenter: false,
                        isBold: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          height: 4,
                          width: 4,
                          decoration: const BoxDecoration(
                            color: Palette.semiNormalTv,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      TextViewCustom(
                        text: comments.time!,
                        fontSize: Converts.c12,
                        tvColor: Palette.semiTv,
                        isTextAlignCenter: false,
                        isBold: false,
                      ),
                    ],
                  ),
                  SizedBox(height: Converts.c8), // Space for better alignment
                  TextViewCustom(
                    text: comments.body!,
                    fontSize: Converts.c16,
                    tvColor: Palette.semiTv,
                    isTextAlignCenter: false,
                    isBold: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
