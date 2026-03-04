import 'package:flutter/material.dart';
import 'package:tmbi/screens/new_task/task_deatil_screen.dart';

import '../../config/app_theme.dart';
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
  final VoidCallback? onReturn;
  final VoidCallback? onLongPress;

  const TaskItem(
      {super.key,
      //required this.title,
      //required this.staff,
      required this.completionText,
      required this.completionColor,
      required this.task,
      required this.staffId,
      required this.onCommentTap,
      this.onReturn,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final assignName = task.assignToName.trim();
    final initials =
        assignName.isNotEmpty ? assignName.characters.first.toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TaskDetailsScreen(
                  index: 0,
                  assignName: task.assignToName,
                  taskId: task.id,
                  staffId: staffId,
                ),
              ),
            );
            onReturn?.call();
          },
          onLongPress: onLongPress,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.outline),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: completionColor.withOpacity(0.9),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  task.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _StatusChip(
                                text: completionText,
                                color: completionColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 9,
                                backgroundColor: completionColor.withOpacity(0.14),
                                child: Text(
                                  initials,
                                  style: textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: completionColor.withOpacity(0.9),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  task.assignToName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall
                                      ?.copyWith(color: AppColors.muted),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  onCommentTap();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CommentsScreen(
                                        staffId: staffId,
                                        inqId: task.id,
                                      ),
                                    ),
                                  );
                                  onReturn?.call();
                                },
                                borderRadius: BorderRadius.circular(999),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.comment_rounded,
                                        size: 12,
                                        color: AppColors.muted,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        task.commentCount,
                                        style: textTheme.labelSmall?.copyWith(
                                          color: AppColors.muted,
                                          fontWeight: FontWeight.w800,
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
                  ),
                  const SizedBox(width: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: color.withOpacity(0.9),
        ),
      ),
    );
  }
}
