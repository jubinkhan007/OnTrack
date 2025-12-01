import 'package:flutter/material.dart';
import 'package:tmbi/screens/new_task/task_deatil_screen.dart';

import '../../models/new_task/task_response.dart';

class TaskItem extends StatelessWidget {
  //final String title;
  //final String staff;
  final String completionText;
  final Color completionColor;
  final Task task;

  const TaskItem(
      {super.key,
      //required this.title,
      //required this.staff,
      required this.completionText,
      required this.completionColor,
      required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailsScreen.create(0, task), // show demoTasks[0]
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
                  Text(task.assignToName, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text(
              completionText,
              style: TextStyle(
                  fontSize: 12,
                  color: completionColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
