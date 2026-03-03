import 'package:flutter/material.dart';
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
    final canUpdate = subtask.assignToId == staffId && !isDone;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: canUpdate ? () => onUpdate(subtask.id.toString()) : null,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.outline),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left color bar
                    Container(
                      width: 5,
                      decoration: BoxDecoration(
                        color: base.withOpacity(0.9),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Row 1: task name + completion chip
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
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: base.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border:
                                      Border.all(color: base.withOpacity(0.25)),
                                ),
                                child: Text(
                                  isDone
                                      ? "Done"
                                      : "${subtask.completion}%",
                                  style: textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: base.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Row 2: assignee avatar + name + date
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: base.withOpacity(0.12),
                                child: Text(
                                  initial,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: base.withOpacity(0.9),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
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
                          const SizedBox(height: 3),
                          // Row 3: reminder + last note + comment (single row)
                          Row(
                            children: [
                              // Bell icon (assignee only)
                              if (onReminderTap != null) ...[
                                InkWell(
                                  onTap: onReminderTap,
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 2, 4, 2),
                                    child: Icon(
                                      reminderText != null
                                          ? Icons.notifications_active
                                          : Icons.notifications_none,
                                      size: 13,
                                      color: reminderText != null
                                          ? base.withOpacity(0.8)
                                          : AppColors.muted,
                                    ),
                                  ),
                                ),
                                if (reminderText != null &&
                                    onReminderClear != null)
                                  InkWell(
                                    onTap: onReminderClear,
                                    borderRadius: BorderRadius.circular(4),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 2, 6, 2),
                                      child: Icon(Icons.close,
                                          size: 11, color: AppColors.muted),
                                    ),
                                  ),
                              ],
                              // Last note (expanded)
                              Expanded(
                                child: Text(
                                  subtask.lastComment != "null"
                                      ? subtask.lastComment
                                      : "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: Converts.c16 - 5,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ),
                              // Comment icon + count
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
                                      horizontal: 6, vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.comment,
                                          size: 12, color: AppColors.muted),
                                      const SizedBox(width: 2),
                                      Text(
                                        subtask.commentCount,
                                        style: TextStyle(
                                          fontSize: Converts.c16 - 5,
                                          color: AppColors.muted,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
            ),
          ),
        ),
      ),
    );
  }
}
