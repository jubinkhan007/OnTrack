import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tmbi/screens/new_task/task_deatil_screen.dart';

import '../../config/converts.dart';
import '../../models/new_task/task_response.dart';
import '../../screens/new_task/comment_screen.dart';

class TaskItem extends StatelessWidget {
  //final String title;
  //final String staff;
  final String completionText;
  final Color completionColor;
  final Task task;
  final String staffId;
  final Function() onCommentTap;

  const TaskItem(
      {super.key,
      //required this.title,
      //required this.staff,
      required this.completionText,
      required this.completionColor,
      required this.task,
      required this.staffId,
      required this.onCommentTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (_) => TaskDetailsScreen.create(0, task), // show demoTasks[0]
            builder: (_) => TaskDetailsScreen(
              index: 0,
              assignName: task.assignToName,
              taskId: task.id,
              staffId: staffId,
            ), // show demoTasks[0]
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.name, style: const TextStyle(fontSize: 14)),
                  Text(task.assignToName,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  completionText,
                  style: TextStyle(
                      fontSize: 12,
                      color: completionColor,
                      fontWeight: FontWeight.bold),
                ),
                Platform.isAndroid
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommentsScreen(
                                staffId: staffId,
                                inqId: task.id,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        // optional for rounded ripple
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.comment,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                task.commentCount,
                                style: TextStyle(
                                    fontSize: Converts.c16 - 4,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
