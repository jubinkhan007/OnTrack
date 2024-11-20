import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/comment_response.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';

class CommentList extends StatelessWidget {
  final Discussion comment;

  const CommentList({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Converts.c8, right: Converts.c8, top:  Converts.c8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        // This will prevent the Row from taking full width
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Palette.navyBlueColor,
                // Border color for the circular stock
                width: 1.0, // Border width
              ),
              shape: BoxShape.circle, // Ensures the container is circular
            ),
            child: ClipOval(
              child: SizedBox(
                width: Converts.c48,
                height: Converts.c48,
                child: CachedNetworkImage(
                  imageUrl:
                      "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/${comment.staffId}/${comment.staffId}-0.jpg",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    width: Converts.c16,
                    height: Converts.c16,
                    child: const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Palette.mainColor),
                      strokeWidth: 2.0,
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Icon(
                      Icons.account_circle,
                      color: Palette.normalTv,
                      size: Converts.c48,
                    ); // Fallback icon when the image fails to load
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: Converts.c8),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Converts.c272),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Converts.c8), // Rounded corners
              ),
              elevation: 1, // Shadow effect
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(Converts.c8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextViewCustom(
                      text: comment.name!,
                      fontSize: Converts.c16,
                      tvColor: Palette.mainColor,
                      isTextAlignCenter: false,
                      isRubik: false,
                      isBold: true,
                    ),
                    Row(
                      children: [
                        TextViewCustom(
                          text: comment.dateTime != null
                              ? comment.dateTime!.split("T")[0]
                              : "",
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
                          text: comment.dateTime != null
                              ? comment.dateTime!.split("T")[1]
                              : "",
                          fontSize: Converts.c12,
                          tvColor: Palette.semiTv,
                          isTextAlignCenter: false,
                          isBold: false,
                        ),
                      ],
                    ),
                    SizedBox(height: Converts.c8), // Space for better alignment
                    TextViewCustom(
                      text: comment.body!,
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
      ),
    );
  }
}
