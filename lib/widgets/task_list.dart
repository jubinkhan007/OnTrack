import 'package:flutter/material.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/screens/dialog/update_task_dialog.dart';
import 'package:tmbi/screens/note_screen.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../models/models.dart';
import '../screens/attachment_view_screen.dart';

class TaskList extends StatefulWidget {
  final Task task;
  final String inquiryId;

  const TaskList({super.key, required this.task, required this.inquiryId});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdateTaskDialog(
            task: widget.task,
            inquiryId: widget.inquiryId,
            onCall: (hasUpdate, flag) {
              setState(() {
                widget.task.status = flag;
                widget.task.isUpdated = hasUpdate;
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.task.hasAccess
            ? widget.task.isUpdated
                ? Colors.green.withOpacity(0.1)
                : Colors.purple.withOpacity(0.1)
            : widget.task.isUpdated
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
          /// title & status
          Row(
            children: [
              Expanded(
                child: TextViewCustom(
                    text: widget.task.name,
                    fontSize: Converts.c16,
                    tvColor: Palette.normalTv,
                    isTextAlignCenter: false,
                    isRubik: false,
                    isBold: true),
              ),
              Container(
                decoration: BoxDecoration(
                  color: widget.task.status.statusColor,
                  // Set your desired background color here
                  // Set your desired background color here
                  borderRadius: BorderRadius.circular(
                      Converts.c12), // Adjust the radius for roundness
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: TextViewCustom(
                    text: widget.task.status,
                    fontSize: Converts.c12,
                    tvColor: Colors.black,
                    isTextAlignCenter: false,
                    isRubik: false,
                    isBold: true),
              ),
            ],
          ),

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
                text: widget.task.assignedPerson,
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
                text: widget.task.date,
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
                      bgColor: widget.task.hasAccess
                          ? widget.task.isUpdated
                              ? Colors.green
                              : Colors.purple
                          : widget.task.isUpdated
                              ? Colors.green
                              : Palette.iconColor,
                      hasOpacity: false,
                      tvColor: Colors.white,
                      fontSize: 14,
                      text: widget.task.hasAccess
                          ? widget.task.isUpdated
                              ? "Complete"
                              : "Update"
                          : widget.task.isUpdated
                              ? "Complete"
                              : "Pending",
                      onTap: () {
                        if (widget.task.hasAccess && !widget.task.isUpdated) {
                          _showDialog(context);
                        }
                      }),
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
                      text: widget.task.date.split("To")[1].trim(),
                      onTap: () {})
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
                        arguments: {
                          'inquiryId': widget.inquiryId.toString(),
                          'taskId': widget.task.id.toString(),
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Converts.c16,
                        right: Converts.c8,
                        top: Converts.c8,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          // Background color of the circle (customize as needed)
                          shape: BoxShape
                              .circle, // This makes the container circular
                        ),
                        padding: EdgeInsets.all(Converts.c8),
                        // Padding around the icon inside the circle
                        child: Icon(
                          Icons.note,
                          color: Colors.white,
                          // Color of the icon (customize as needed)
                          size: Converts.c20, // Icon size (customize as needed)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AttachmentViewScreen.routeName,
                        arguments: {
                          'inquiryId': widget.inquiryId.toString(),
                          'taskId': widget.task.id.toString(),
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Converts.c8,
                        right: Converts.c8,
                        top: Converts.c8,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          // Background color of the circle (customize as needed)
                          shape: BoxShape
                              .circle, // This makes the container circular
                        ),
                        padding: EdgeInsets.all(Converts.c8),
                        child: Icon(
                          Icons.attach_file,
                          color: Colors.white,
                          size: Converts.c20,
                        ),
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
