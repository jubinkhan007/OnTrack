import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/screens/todo/custom_dropdown.dart';

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
  final TextEditingController _taskController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isChecked = false;

  final List<String> userNames = [
    'Md. Elias',
    'Salauddin',
    'Emrul Kaise',
    'Asad',
    'Mithun Kumar',
  ];
  List<String> filteredUsers = [];

  void _onTextChanged(String text) {
    final atSymbolIndex = text.indexOf('@');
    if (atSymbolIndex != -1) {
      final afterAtText = text.substring(atSymbolIndex + 1);
      if (afterAtText.length >= 3) {
        _searchForUsers(afterAtText);
        debugPrint("Called: $afterAtText ${afterAtText.length}");
      } else {
        setState(() {
          filteredUsers.clear();
        });
      }
    }
  }

  // This method filters the list of users based on the query
  void _searchForUsers(String query) {
    setState(() {
      filteredUsers = userNames
          .where((user) => user.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  int findAtSymbol(String value) {
    int count = 0;
    RegExp regExp = RegExp(r'@');
    Iterable<Match> matches = regExp.allMatches(value);
    count = matches.length;
    debugPrint("Count:: $count");
    return count;
  }

  // add task to the list
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        //tasks.add(_taskController.text);
        taskes.add({
          'taskTitle': _taskController.text,
          'date': 'Jan 25, 2025',
          'imageUrls': ['340553'],
          'isChecked': _isChecked,
        });
        _taskController.clear(); // Clear the input after adding the task
        _focusNode.unfocus(); // Dismiss the keyboard
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _taskController.addListener(() {
      _onTextChanged(_taskController.text);
    });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Converts.c8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CustomDropdown(items: const [
              "Sorted by Created Date",
              "Completed",
              "3 days later"
            ], hintName: "Sorted by", onChanged: (value) {}),
          ),
          SizedBox(
            height: Converts.c12,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskes.length,
              itemBuilder: (context, index) {
                final task = taskes[index];
                return itemTodoTask(task['isChecked'], task['taskTitle'],
                    task['date'], ['340553', "123456"], (value) {
                  setState(() {
                    taskes[index]['isChecked'] = value;
                  });
                });
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
          // filtered user list only if there are matches
          if (filteredUsers.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  //color: Colors.deepOrange,
                  height: Converts.c104,
                  // Set a fixed height for the user list
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredUsers[index]),
                        onTap: () {
                          String selectedUser = filteredUsers[index];
                          // Check if the string starts with "@"
                          // Get the current text from the TextField
                          String currentText = _taskController.text.trim();

                          // Check if the string contains "@"
                          if (currentText.contains('@')) {
                            // Find the position of the '@' symbol
                            int atIndex = currentText.indexOf('@');

                            // Get the text before '@'
                            String textBeforeAt =
                                currentText.substring(0, atIndex).trim();

                            // Update the text in the TextField without '@' and everything after it
                            setState(() {
                              _taskController.text = textBeforeAt;
                              filteredUsers.clear();
                            });

                            // Move the cursor to the end of the updated text
                            _taskController.selection = TextSelection.collapsed(
                                offset: _taskController.text.length);

                            debugPrint("Updated Text: $textBeforeAt");
                          } else {
                            debugPrint("Updated Text: not containing @");
                          }
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
              ],
            ),
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

  Widget itemTodoTask(
    bool isChecked,
    String taskName,
    String date,
    List<String> ids,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 2.0,
        bottom: 2,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    onChanged(value!);
                  },
                  shape: const CircleBorder(),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Uri.decodeComponent(taskName),
                        style: GoogleFonts.roboto(
                          fontSize: Converts.c16,
                          color: Palette.semiTv,
                          fontWeight: FontWeight.bold,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextViewCustom(
                            text: date,
                            fontSize: Converts.c12,
                            tvColor: Palette.semiNormalTv,
                            isBold: false,
                            isRubik: false,
                          ),
                          ids.isNotEmpty
                              ? attachUsers(ids)
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: Converts.c8,
            )
          ],
        ),
      ),
    );
  }

  Widget attachUsers(List<String> users) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          ...users.take(2).map((id) {
            return ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/$id/$id-0.jpg",
                width: Converts.c20,
                height: Converts.c20,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(
                  Icons.account_circle,
                  size: Converts.c20,
                ),
              ),
            );
          }),
          users.length > 2
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    height: Converts.c20,
                    width: Converts.c20,
                    color: Colors.grey[300], // You can change the color
                    child: Center(
                      child: TextViewCustom(
                        text: "${users.length - 2}+",
                        fontSize: Converts.c12,
                        tvColor: Colors.black,
                        isBold: true,
                        isRubik: false,
                        isTextAlignCenter: true,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> taskes = [
    {
      'taskTitle': 'Complete Flutter task',
      'date': 'Jan 22, 2025',
      'imageUrls': ['340553'],
      'isChecked': false,
    },
    {
      'taskTitle': 'Review PR',
      'date': 'Jan 23, 2025',
      'imageUrls': [
        '340553',
        '397820',
      ],
      'isChecked': true,
    },
    {
      'taskTitle': 'Test the app',
      'date': 'Jan 24, 2025',
      'imageUrls': ['340553'],
      'isChecked': false,
    },
  ];
}
