import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/comment_response.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';

class IndividualTaskList extends StatelessWidget {
  final Discussion task;

  const IndividualTaskList({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Converts.c8, right: Converts.c8, top: Converts.c8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        // This will prevent the Row from taking full width
        children: [
          Row(
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
                    width: Converts.c32,
                    height: Converts.c32,
                    child: CachedNetworkImage(
                      imageUrl:
                          "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/${task.staffId}/${task.staffId}-0.jpg",
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
                          Icons.account_circle_outlined,
                          color: Palette.normalTv,
                          size: Converts.c32,
                        ); // Fallback icon when the image fails to load
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Converts.c16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewCustom(
                    text: task.name!,
                    fontSize: Converts.c16,
                    tvColor: Palette.normalTv,
                    isTextAlignCenter: false,
                    isRubik: false,
                    isBold: true,
                  ),
                  TextViewCustom(
                    text: task.dateTime!,
                    fontSize: Converts.c16,
                    tvColor: Palette.semiNormalTv,
                    isTextAlignCenter: false,
                    isRubik: false,
                    isBold: false,
                  )
                ],
              ),
            ],
          ),
          SizedBox(width: Converts.c8),
          TextViewCustom(
            text: task.body!,
            fontSize: Converts.c16,
            tvColor: Palette.normalTv,
            isTextAlignCenter: false,
            isRubik: false,
            isBold: false,
          ),
          SizedBox(height: Converts.c8),
          const Divider(
            height: 0.5,
            color: Colors.black12,
          ),
          SizedBox(height: Converts.c8, ),
        ],
      ),
    );
  }
}
