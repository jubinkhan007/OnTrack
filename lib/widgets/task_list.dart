import 'package:flutter/material.dart';
import 'package:tmbi/screens/dialog/update_task_dialog.dart';
import 'package:tmbi/screens/note_screen.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../models/models.dart';
import '../screens/attachment_view_screen.dart';

class TaskList extends StatelessWidget {
  final Task task;

  const TaskList({super.key, required this.task});

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdateTaskDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: task.hasAccess
            ? task.isUpdated
                ? Colors.green.withOpacity(0.1)
                : Colors.purple.withOpacity(0.1)
            : task.isUpdated
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
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
              tvColor: Palette.normalTv,
              isTextAlignCenter: false,
              isRubik: false,
              isBold: true),

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
          /// date
          Row(
            children: [
              Icon(
                Icons.date_range,
                color: Palette.semiTv,
                size: Converts.c20,
              ),
              SizedBox(
                width: Converts.c8,
              ),
              TextViewCustom(
                text: task.date,
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
                              : Palette.iconColor,
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
                      onTap: () {
                        if (task.hasAccess && !task.isUpdated) {
                          _showDialog(context);
                        }
                      }),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  /*ButtonCircularIcon(
                      height: Converts.c24,
                      width: Converts.c96,
                      radius: 4,
                      bgColor: Colors.black,
                      hasOpacity: false,
                      tvColor: Colors.white,
                      fontSize: 8,
                      iconData: Icons.flag_outlined,
                      //text: task.date.split("-")[1].split(",")[0],
                      text: task.date,
                      onTap: () {})*/
                ],
              ),
              // icon
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NoteScreen.routeName,
                        //arguments: task.id, // Pass the list as arguments
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Converts.c16,
                        right: Converts.c8,
                        top: Converts.c8,
                      ),
                      child: Icon(
                        Icons.note,
                        color: Colors.black,
                        size: Converts.c20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Converts.c16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AttachmentViewScreen.routeName,
                        arguments: task.id, // Pass the list as arguments
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Converts.c8,
                        right: Converts.c8,
                        top: Converts.c8,
                      ),
                      child: Icon(
                        Icons.attach_file,
                        color: Colors.black,
                        size: Converts.c20,
                      ),
                    ),
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
