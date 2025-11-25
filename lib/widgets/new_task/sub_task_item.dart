import 'package:flutter/material.dart';

import '../../models/new_task/sub_task.dart';

class SubTaskItem extends StatelessWidget {
  final SubTask subtask;

  const SubTaskItem({super.key, required this.subtask});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  subtask.completed ? Icons.check_circle : Icons.circle_outlined,
                  color: subtask.completed ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    subtask.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: subtask.completed ? Colors.green[100] : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subtask.completed ? "Completed" : "In Progress",
                    style: TextStyle(
                      color: subtask.completed ? Colors.green : Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            Text("Assigned to ${subtask.assignee}"),
            Text(subtask.dateRange),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: subtask.progress / 100,
              minHeight: 4,
              color: subtask.completed ? Colors.green : Colors.orange,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Text("${subtask.progress}%"),
          ],
        ),
      ),
    );
  }
}
