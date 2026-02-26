import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:tmbi/models/new_task/notification_response.dart';
import 'package:tmbi/config/app_theme.dart';

import '../../config/converts.dart';

class NotificationItem extends StatelessWidget {
  final Notification model;

  const NotificationItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText = model.notifType == "New Task"
        ? "${model.assignName} assigned a new task, '${model.notifBody}' to you."
        : model.notifBody;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: Converts.c20,
                    backgroundColor: AppColors.accent.withOpacity(0.12),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/${model.assignId}/${model.assignId}-0.jpg",
                        fit: BoxFit.cover,
                        width: Converts.c40,
                        height: Converts.c40,
                        placeholder: (_, __) => const Icon(
                          Icons.person_outline,
                          color: AppColors.accent,
                        ),
                        errorWidget: (_, __, ___) => const Icon(
                          Icons.person_outline,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bodyText,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          model.time,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Text(
                            model.notifType,
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary.withOpacity(0.85),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          model.date,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
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
    );
  }
}
