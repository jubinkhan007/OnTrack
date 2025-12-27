import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/size_config.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/models/new_task/main_task_response.dart';

import '../../config/converts.dart';
import '../../screens/new_task/comment_screen.dart';

class SubTaskItem extends StatelessWidget {
  final SubTask subtask;
  final String mainTaskId;
  final String staffId;
  final void Function(String subtaskId) onUpdate;

  const SubTaskItem({
    super.key,
    required this.subtask,
    required this.staffId,
    required this.onUpdate,
    required this.mainTaskId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: subtask.completion == "100"
          ? Colors.green.shade50
          : Colors.red.shade50,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8, top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /*Icon(
                  subtask.completion == "100"
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: subtask.completion == "100" ? Colors.green : Colors.orange,
                  size: Converts.c16,
                ),*/
                Icon(
                  subtask.completion == "100"
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: subtask.completion == "100"
                      ? Colors.green
                      : Colors.orange,
                  size: Converts.c16,
                ),

                const SizedBox(width: 8),
                // --- Title --- \\
                Expanded(
                  child: Text(
                    subtask.name,
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
                    color: subtask.completion == "100"
                        ? Colors.green[100]
                        : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subtask.completion == "100"
                        ? "Completed | ${subtask.completion}% "
                        : "In Progress | ${subtask.completion}%",
                    style: TextStyle(
                        color: subtask.completion == "100"
                            ? Colors.green
                            : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 2),
            subtask.assignToName.withDate(" ${Strings.dot} ${subtask.date}",
                fontSize: Converts.c12),
            /*Row(
              children: [
                /*Text(
                  Strings.assignedTo,
                  style: TextStyle(fontSize: Converts.c12),
                ),*/
                Text(
                  " ${subtask.assignToName}",
                  style: TextStyle(
                      fontSize: Converts.c12 - 2, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text("${Strings.dot} ${subtask.date}",
                      style: TextStyle(fontSize: Converts.c12 - 2)),
                ),
                //Text(" | ${subtask.progress}%", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
              ],
            ),*/
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Last Note# ${subtask.lastComment}",
                    style: TextStyle(
                        fontSize: Converts.c16 - 4, color: Colors.purpleAccent),
                  ),
                ),
                Platform.isAndroid
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommentsScreen(
                                staffId: staffId,
                                inqId: mainTaskId,
                                subTask: subtask,
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
                                subtask.commentCount,
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
            subtask.assignToId == staffId && subtask.completion != "100"
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          onUpdate(subtask.id.toString());
                        }, // your callback function
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          minimumSize: Size.zero, // makes the button small
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),

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
