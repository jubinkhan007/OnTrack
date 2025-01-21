import 'package:flutter/material.dart';

class Demo extends StatelessWidget {
  final String taskTitle;
  final String date;
  final bool isChecked;

  Demo({
    required this.taskTitle,
    required this.date,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Row(
        children: [
          // Checkbox with CircleShape
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {},
            shape: CircleBorder(),
          ),
          SizedBox(width: 10), // Add space between checkbox and text

          // Column for Task Title and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskTitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4), // Space between task title and date
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
