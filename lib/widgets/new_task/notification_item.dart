import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:tmbi/models/new_task/notification_response.dart';

import '../../config/converts.dart';

class NotificationItem extends StatelessWidget {
  final Notification model;

  const NotificationItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              /*CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue.shade50,
                child: const Icon(
                  Icons.person_outline,
                  size: 22,
                  color: Colors.blue,
                ),
              ),*/
              CircleAvatar(
                radius: Converts.c20,
                backgroundColor: Colors.blue.shade50,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/${model.assignId}/${model.assignId}-0.jpg",
                    fit: BoxFit.cover,
                    width: Converts.c40,
                    height: Converts.c40,
                    placeholder: (_, __) =>
                        const Icon(Icons.person_outline, color: Colors.blue),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.person_outline, color: Colors.blue),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
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
                Text(
                  model.notifType == "New Task"
                      ? "${model.assignName} assigned a new task, '${model.notifBody}' to you."
                      : model.notifBody,
                  style: TextStyle(
                    fontSize: Converts.c16 - 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${model.notifType} • ${model.date}",
                  style: TextStyle(
                    fontSize: Converts.c16 - 4,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                /*Text(
                  model.assignName, // or project name
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                  ),
                ),*/
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              model.time,
              style: TextStyle(
                fontSize: Converts.c16 - 4,
                color: Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
