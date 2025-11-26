import 'package:flutter/material.dart';
import 'package:tmbi/config/strings.dart';

import '../../config/converts.dart';
import '../../models/new_task/sub_task.dart';

class SubTaskItem extends StatelessWidget {
  final SubTask subtask;

  const SubTaskItem({super.key, required this.subtask});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: subtask.completed ? Colors.green.shade50 : Colors.red.shade50,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8, top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  subtask.completed
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: subtask.completed ? Colors.green : Colors.orange,
                  size: Converts.c16,
                ),
                const SizedBox(width: 8),
                // --- Title --- \\
                Expanded(
                  child: Text(
                    subtask.title,
                    style: TextStyle(
                      fontSize: Converts.c16 - 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // status
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: subtask.completed
                        ? Colors.green[100]
                        : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subtask.completed
                        ? "Completed | ${subtask.progress}% "
                        : "In Progress | ${subtask.progress}%",
                    style: TextStyle(
                        color: subtask.completed ? Colors.green : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            //const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  Strings.assignedTo,
                  style: TextStyle(fontSize: Converts.c12),
                ),
                Text(
                  " ${subtask.assignee}",
                  style: TextStyle(
                      fontSize: Converts.c12 - 2, fontWeight: FontWeight.bold),
                ),
                Text("${Strings.dot} ${subtask.dateRange}",
                    style: TextStyle(fontSize: Converts.c12 - 2)),
                //Text(" | ${subtask.progress}%", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
              ],
            ),
            //Text(subtask.dateRange),
            //const SizedBox(height: 8),
            /*LinearProgressIndicator(
              value: subtask.progress / 100,
              minHeight: 4,
              color: subtask.completed ? Colors.green : Colors.orange,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 4),*/
            //Text("${subtask.progress}%"),
          ],
        ),
      ),
    );
  }
}
