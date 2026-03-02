import 'package:flutter/material.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/config/app_theme.dart';
import 'package:tmbi/models/new_task/main_task_response.dart';

import '../../config/converts.dart';
import '../../screens/new_task/comment_screen.dart';

class SubTaskItem extends StatelessWidget {
  final SubTask subtask;
  final String mainTaskId;
  final String staffId;
  final void Function(String subtaskId) onUpdate;
  final String? reminderText;
  final VoidCallback? onReminderTap;
  final VoidCallback? onReminderClear;
  final VoidCallback? onReturn;

  const SubTaskItem({
    super.key,
    required this.subtask,
    required this.staffId,
    required this.onUpdate,
    required this.mainTaskId,
    this.reminderText,
    this.onReminderTap,
    this.onReminderClear,
    this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDone = subtask.completion == "100";
    final base = isDone ? AppColors.success : AppColors.warning;
    final name = (subtask.assignToName).trim();
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section: bar + name/assignee content
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 5,
                        decoration: BoxDecoration(
                          color: base.withOpacity(0.9),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    subtask.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: base.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                        color: base.withOpacity(0.25)),
                                  ),
                                  child: Text(
                                    isDone
                                        ? "Completed • ${subtask.completion}%"
                                        : "In Progress • ${subtask.completion}%",
                                    style: textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: base.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: base.withOpacity(0.12),
                                  child: Text(
                                    initial,
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: base.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${subtask.assignToName} ${Strings.dot} ${subtask.date}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.muted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Reminder row (assignee only)
                if (onReminderTap != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: onReminderTap,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15, 4, 4, 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.notifications_none,
                                  size: 16,
                                  color: AppColors.muted,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    reminderText == null
                                        ? "Add reminder"
                                        : "Remind me at $reminderText",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Converts.c16 - 4,
                                      color: AppColors.muted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (reminderText != null && onReminderClear != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          color: AppColors.muted,
                          onPressed: onReminderClear,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                    ],
                  ),
                ],

                // Last note + comment button
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          subtask.lastComment != "null"
                              ? "Last Note • ${subtask.lastComment}"
                              : "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: Converts.c16 - 4,
                              color: AppColors.muted),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommentsScreen(
                                staffId: staffId,
                                inqId: mainTaskId,
                                subTask: subtask,
                              ),
                            ),
                          );
                          onReturn?.call();
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.comment,
                                size: 16,
                                color: AppColors.muted,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                subtask.commentCount,
                                style: TextStyle(
                                    fontSize: Converts.c16 - 4,
                                    color: AppColors.muted,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Update button (assignee + incomplete only)
                if (subtask.assignToId == staffId &&
                    subtask.completion != "100")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: () => onUpdate(subtask.id.toString()),
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
