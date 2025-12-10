import 'package:flutter/material.dart';

import '../../config/converts.dart';
import '../../config/enum.dart';
import '../../config/strings.dart';


class StatusCards extends StatelessWidget {
  final String pending;
  final String overdue;
  final String completed;
  final Function(TaskStatusFlag tsf) onFinalTap;

  const StatusCards({
    super.key,
    required this.pending,
    required this.overdue,
    required this.completed,
    required this.onFinalTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Converts.c8, top: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _statusBox(Strings.pending, pending.toString(), Colors.orange[100]!, () {
              onFinalTap(TaskStatusFlag.pending);
            }),
            SizedBox(width: Converts.c8),
            _statusBox(Strings.overdue1, overdue.toString(), Colors.red[100]!, () {
              onFinalTap(TaskStatusFlag.overdue);
            }),
            SizedBox(width: Converts.c8),
            _statusBox(Strings.completed, completed.toString(), Colors.green[100]!, () {
              onFinalTap(TaskStatusFlag.completed);
            }),
          ],
        ),
      ),
    );
  }

  Widget _statusBox(String label, String value, Color color, Function() onStatusTap) {
    return GestureDetector(
      onTap: () {
        onStatusTap();
      },
      child: Container(
        width: Converts.c112,
        padding: EdgeInsets.all(Converts.c8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Converts.c12),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: Converts.c12, color: Colors.black54)),
            //SizedBox(height: Converts.c8),
            Text(value, style: TextStyle(fontSize: Converts.c20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
