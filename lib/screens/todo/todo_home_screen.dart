import 'package:flutter/material.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/screens/todo/demo.dart';

import '../../config/converts.dart';
import '../../config/strings.dart';
import '../../widgets/widgets.dart';

class TodoHomeScreen extends StatefulWidget {
  static const String routeName = '/todo_home_screen';

  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final List<String> tasks = [
    'Buy groceries',
    'Finish homework',
    'Call mom',
    'Go for a walk',
  ];

  TextEditingController _taskController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isChecked = false;

  // Method to add task to the list
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(_taskController.text);
        _taskController.clear(); // Clear the input after adding the task
        _focusNode.unfocus(); // Dismiss the keyboard
      });
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.mainColor,
        centerTitle: false,
        title: TextViewCustom(
          text: Strings.tasks,
          fontSize: Converts.c20,
          tvColor: Colors.white,
          isTextAlignCenter: false,
          isRubik: false,
          isBold: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          // Customize icon color
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              /*itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  leading: Icon(Icons.check_circle_outline),
                );
              },*/
              itemCount: taskes.length,
              itemBuilder: (context, index) {
                final task = taskes[index];
                return Demo(
                  taskTitle: task['taskTitle'],
                  date: task['date'],
                  //imageUrls: List<String>.from(task['imageUrls']),
                  isChecked: task['isChecked'],
                );
              },
            ),
          ),
          bottomTextField(),
        ],
      ),
    );
  }

  Widget bottomTextField() {
    return Container(
      padding: EdgeInsets.all(Converts.c16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Converts.c20),
          topRight: Radius.circular(Converts.c20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: Converts.c8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value ?? false;
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _taskController,
                  focusNode: _focusNode,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      hintText: Strings.add_a_task,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Palette.circleColor)),
                  style: TextStyle(fontSize: Converts.c16),
                  onEditingComplete: _addTask, // Add task on done
                ),
              )
            ],
          ),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.date_range,
                    size: Converts.c16,
                  ),
                  onPressed: () {},
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    size: Converts.c16,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  final List<Map<String, dynamic>> taskes = [
    {
      'taskTitle': 'Complete Flutter task',
      'date': 'Jan 22, 2025',
      'imageUrls': [
        'https://www.example.com/user1.jpg',
        'https://www.example.com/user2.jpg',
        'https://www.example.com/user3.jpg',
        'https://www.example.com/user4.jpg',
      ],
      'isChecked': false,
    },
    {
      'taskTitle': 'Review PR',
      'date': 'Jan 23, 2025',
      'imageUrls': [
        'https://www.example.com/user5.jpg',
        'https://www.example.com/user6.jpg',
      ],
      'isChecked': true,
    },
    {
      'taskTitle': 'Test the app',
      'date': 'Jan 24, 2025',
      'imageUrls': [
        'https://www.example.com/user7.jpg',
      ],
      'isChecked': false,
    },
  ];


}
