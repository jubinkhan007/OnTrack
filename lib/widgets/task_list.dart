import 'package:flutter/material.dart';
import 'package:tmbi/data/inquiry_response.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../config/palette.dart';

class TaskList extends StatelessWidget {
  final Task task;

  const TaskList({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: task.hasAccess
            ? task.isUpdated
                ? Colors.green.withOpacity(0.2)
                : Colors.purple.withOpacity(0.2)
            : task.isUpdated
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      //color: Colors.green,
      margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// title
          TextViewCustom(
              text: task.name,
              fontSize: Converts.c16,
              tvColor: Colors.black,
              isTextAlignCenter: false,
              isBold: false),

          /// completer name
          Row(
            children: [
              Icon(
                Icons.account_circle,
                color: Palette.semiTv,
                size: Converts.c20,
              ),
              SizedBox(
                width: Converts.c8,
              ),
              TextViewCustom(
                text: task.assignedPerson,
                fontSize: Converts.c16,
                tvColor: Palette.semiTv,
                isTextAlignCenter: false,
                isBold: false,
              ),
            ],
          ),
          SizedBox(
            height: Converts.c16,
          ),

          /// flag & icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // flag
              Row(
                children: [
                  ButtonCircularIcon(
                      height: Converts.c24,
                      width: Converts.c96,
                      radius: 4,
                      bgColor: task.hasAccess
                          ? task.isUpdated
                              ? Colors.green
                              : Colors.purple
                          : task.isUpdated
                              ? Colors.green
                              : Colors.orange,
                      hasOpacity: false,
                      tvColor: Colors.white,
                      fontSize: 14,
                      text: task.hasAccess
                          ? task.isUpdated
                              ? "Complete"
                              : "Update"
                          : task.isUpdated
                              ? "Complete"
                              : "Pending",
                      onTap: () {}),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  ButtonCircularIcon(
                      height: Converts.c24,
                      width: Converts.c96,
                      radius: 4,
                      bgColor: Colors.black,
                      hasOpacity: false,
                      tvColor: Colors.white,
                      fontSize: 14,
                      iconData: Icons.flag_outlined,
                      text: task.date.split("-")[1].split(",")[0],
                      onTap: () {})
                ],
              ),
              // icon
              Row(
                children: [
                  Icon(
                    Icons.note,
                    color: Colors.black,
                    size: Converts.c20,
                  ),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  Icon(
                    Icons.attach_file,
                    color: Colors.black,
                    size: Converts.c20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
