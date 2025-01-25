import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/screens/todo/custom_dropdown.dart';

import '../../config/converts.dart';
import '../../config/sp_helper.dart';
import '../../config/strings.dart';
import '../../models/models.dart';
import '../../network/ui_state.dart';
import '../../viewmodel/viewmodel.dart';
import '../../widgets/date_selection_view.dart';
import '../../widgets/widgets.dart';

class TodoHomeScreen extends StatefulWidget {
  static const String routeName = '/todo_home_screen';
  final String staffId;

  TodoHomeScreen({super.key, required this.staffId});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // status flag
  String statusFlag = StatusFlag.pending.getFlag;

  // flag
  bool _isChecked = false;
  bool _isDateSelected = false;
  bool _isFileAttached = false;

  // users for assign
  final List<Customer> users = [
    Customer(id: "340553", name: "Md. Salauddin", isVerified: true),
    Customer(id: "340554", name: "Md. Elias Hossain", isVerified: true),
    Customer(id: "340556", name: "Md. Emrul Kaish", isVerified: true),
  ];

  List<Customer> filteredNewUsers = [];
  List<Customer> _addedUsers = [];
  List<Discussion> _assignedTaskToUser = [];

  void _searchForNewUsers(String query) {
    setState(() {
      filteredNewUsers = users
          .where((user) =>
              user.name.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onTextChanged(String text) {
    final atSymbolIndex = text.indexOf('@');
    if (atSymbolIndex != -1) {
      final afterAtText = text.substring(atSymbolIndex + 1);
      if (afterAtText.length >= 3) {
        _searchForNewUsers(afterAtText);
        //debugPrint("Called: $afterAtText ${afterAtText.length}");
      } else {
        setState(() {
          filteredNewUsers.clear();
        });
      }
    }
  }

  // files & date
  final List<ImageFile> imageFiles = [];
  String _selectedDate = DateTime.now().toFormattedString(format: "yyyy-MM-dd");

  // add task to the list
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        /*taskes.add(Todo(
            title: _taskController.text,
            date: _selectedDate,
            isChecked: _isChecked,
            assigns: []));*/
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
    // fetch tasks
    final inquiryViewModel =
        Provider.of<InquiryViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getInquiries(statusFlag, widget.staffId, "1");
    });
    debugPrint("Called");
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
            child: CustomDropdown(
                items: HomeFlagItem().homeFlagItems,
                hintName: "Sorted by",
                onChanged: (value) {
                  if (value != null) {
                    statusFlag = value!.status!.getFlag!;
                    Provider.of<InquiryViewModel>(context, listen: false)
                        .getInquiries(statusFlag, widget.staffId, "1");
                    debugPrint("StatusFlag::$statusFlag");
                  }
                }),
          ),
          SizedBox(
            height: Converts.c12,
          ),

          /// task list
          Consumer<InquiryViewModel>(
              builder: (context, inquiryViewModel, child) {
            if (inquiryViewModel.uiState == UiState.loading) {
              return Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: Converts.c120,
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            } else if (inquiryViewModel.uiState == UiState.error) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: Converts.c120,
                  ),
                  child: ErrorContainer(
                      message: inquiryViewModel.message != null
                          ? inquiryViewModel.message!
                          : Strings.something_went_wrong),
                ),
              );
            }
            // null check
            if (inquiryViewModel.inquiries?.isEmpty ?? true) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: Converts.c120,
                  ),
                  child: ErrorContainer(
                      message: inquiryViewModel.message != null
                          ? inquiryViewModel.message!
                          : Strings.no_data_found),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: inquiryViewModel.inquiries!.length,
                itemBuilder: (context, index) {
                  final inquiryResponse = inquiryViewModel.inquiries![index];
                  return itemTodoTask(inquiryResponse, [], (value) {
                    setState(() {
                      //task = value;
                    });
                  });
                },
              ),
            );
          }),
          bottomTextField(),
        ],
      ),
    );
  }

  Widget bottomTextField() {
    return Consumer<InquiryCreateViewModel>(
        builder: (context, inquiryViewModel, child) {
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
            /// filtered user list only
            /// if there are matches
            if (filteredNewUsers.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    //color: Colors.deepOrange,
                    height: Converts.c104,
                    // Set a fixed height for the user list
                    child: ListView.builder(
                      itemCount: filteredNewUsers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredNewUsers[index].name.toString()),
                          onTap: () {
                            setState(() {
                              _addedUsers.add(filteredNewUsers[index]);
                            });
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
                                filteredNewUsers.clear();
                              });
                              // Move the cursor to the end of the updated text
                              _taskController.selection =
                                  TextSelection.collapsed(
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

            /// check box & task input
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
                    //onEditingComplete: _addTask, // Add task on done
                    onEditingComplete: () async {
                      if (_taskController.text != "" &&
                          _taskController.text != null) {
                        debugPrint("DONE:: ${_taskController.text}");
                        String loggedUserName = await _getUserName();

                        // upload files, if any are selected
                        if (imageFiles.isNotEmpty) {
                          await inquiryViewModel.saveFiles(imageFiles);
                        }
                        // save inquiry
                        await inquiryViewModel.saveInquiry(
                            "0",
                            //mCompanyId,
                            "0",
                            //mInquiryId,
                            //titleController.text,
                            //descriptionController.text,
                            Uri.encodeComponent(_taskController.text),
                            Uri.encodeComponent(_taskController.text),
                            "N",
                            //isSample,
                            _selectedDate,
                            //selectedDate,
                            "401",
                            //mPriorityId,
                            "0",
                            //mCustomer!.id.toString(),
                            "Other",
                            // customerName,
                            widget.staffId,
                            _createAssignTaskForUsers(loggedUserName),
                            inquiryViewModel.files);

                        // check the status of the request
                        if (inquiryViewModel.isSavedInquiry != null) {
                          if (inquiryViewModel.isSavedInquiry!) {
                            //showMessage(Strings.data_saved_successfully);
                            //Navigator.pop(context);
                            // reset all values to default
                            setState(() {
                              resetFields();
                            });
                            // refresh
                            _getTodos();
                          } else {
                            showMessage(Strings.failed_to_save_the_data);
                          }
                        } else {
                          showMessage(Strings.data_is_missing);
                        }
                        /*// reset all values to default
                        setState(() {
                          resetFields();
                        });*/
                      }
                    }, // Add task on done
                  ),
                )
              ],
            ),

            /// assigned person (if any)
            if (_addedUsers.isNotEmpty) assignedUser(),

            /// date, image selection view
            Row(
              children: [
                DateSelectionView(
                  onDateSelected: (date) {
                    if (date != null) {
                      _selectedDate = date;
                    }
                    setState(() {
                      _isDateSelected = true;
                    });
                  },
                  isFromTodo: true,
                  isDateSelected: _isDateSelected,
                ),
                FileAttachment(
                  onFileAttached: (files) {
                    if (files != null) {
                      if (imageFiles.isNotEmpty) {
                        imageFiles.clear();
                      }
                      imageFiles.addAll(files);
                      debugPrint(imageFiles.length.toString());
                      setState(() {
                        _isFileAttached = true;
                      });
                    }
                  },
                  isFromTodo: true,
                  isFileAttached: _isFileAttached,
                )
              ],
            ),

            /// raw image view
            if (_isFileAttached) _imageView()
          ],
        ),
      );
    });
  }

  Widget _imageView() {
    return SizedBox(
      height: Converts.c72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageFiles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Converts.c8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Converts.c16),
                  child: Image.memory(
                    imageFiles[index].file, // Your Uint8List data
                    width: Converts.c56, // Set desired width
                    height: Converts.c56, // Set desired height
                    fit: BoxFit.cover, // Fit the image
                  ),
                ),
                Positioned(
                  top: 4.0, // Adjust the top position
                  right: 4.0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        imageFiles.removeAt(index);
                        if (imageFiles.isEmpty) _isFileAttached = false;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Palette.tabColor,
                      ),
                      child: Icon(
                        Icons.close,
                        size: Converts.c16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _getTodos() {
    Provider.of<InquiryViewModel>(context, listen: false)
        .getInquiries(statusFlag, widget.staffId, "1");
  }

  showMessage(String message) {
    final snackBar = SnackBar(
      content: TextViewCustom(
        text: message,
        tvColor: Colors.white,
        fontSize: Converts.c16,
        isBold: false,
        isRubik: true,
        isTextAlignCenter: false,
      ),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  resetFields() {
    _taskController.text = "";

    _isChecked = false;
    _isDateSelected = false;
    _isFileAttached = false;

    filteredNewUsers.clear();
    _addedUsers.clear();
    _assignedTaskToUser.clear();
    imageFiles.clear();
  }

  Widget itemTodoTask(
    InquiryResponse inquiryResponse,
    List<User> users,
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
                  value: false,
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
                        Uri.decodeComponent(inquiryResponse.title),
                        style: GoogleFonts.roboto(
                          fontSize: Converts.c16,
                          color: Palette.semiTv,
                          fontWeight: FontWeight.bold,
                          decoration: false
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextViewCustom(
                            text: inquiryResponse.endDate,
                            fontSize: Converts.c12,
                            tvColor: Palette.semiNormalTv,
                            isBold: false,
                            isRubik: false,
                          ),
                          users.isNotEmpty
                              ? attachUsers(users)
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

  Widget attachUsers(List<User> users) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          ...users.take(2).map((user) {
            return ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/${user.id}/${user.id}-0.jpg",
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

  Widget assignedUser() {
    return Column(
      children: [
        const Divider(),
        SizedBox(
          height: 24,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _addedUsers.length,
                itemBuilder: (context, index) {
                  Customer user = _addedUsers[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: _assignedUserView(user),
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget _assignedUserView(Customer customer) {
    String displayedName = customer.name!.length > 10
        ? '${customer.name!.substring(0, 10)}...' // Limit to 10 chars and add ellipsis
        : customer.name!;

    return InkWell(
      onTap: () {
        if (_addedUsers.isNotEmpty) {
          setState(() {
            _addedUsers.remove(customer);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 4),
        decoration: BoxDecoration(
          color: Palette.mainColor.withOpacity(0.2),
          borderRadius: BorderRadius.all(
            Radius.circular(Converts.c12),
          ),
          border: Border.all(
            color: Palette.mainColor, // Border color
            width: 0.5, // Border width
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // Make the Row only take as much space as needed
          children: [
            // Text view for the name, limited to 10 chars
            TextViewCustom(
              text: displayedName,
              fontSize: Converts.c12,
              tvColor: Palette.semiTv,
              isBold: true,
            ),
            SizedBox(
              width: Converts.c8, // Space between name and close button
            ),
            // Close button
            Padding(
              padding: EdgeInsets.all(Converts.c8),
              child: Icon(
                Icons.close,
                color: Palette.semiTv,
                size: Converts.c12, // Adjust the size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _createAssignTaskForUsers(String name) {
    // add a logged user discussion first
    _assignedTaskToUser.add(Discussion(
      name: name,
      staffId: widget.staffId,
      dateTime: _selectedDate,
      body: _taskController.text.isNotEmpty
          ? _taskController.text.toString()
          : '',
    ));

    if (_addedUsers.isNotEmpty) {
      for (var user in _addedUsers) {
        _assignedTaskToUser.add(Discussion(
            name: user.name,
            staffId: user.id,
            dateTime: _selectedDate,
            body: _taskController.text.toString()));
      }
    }
    if (_assignedTaskToUser.isNotEmpty) {
      List<Map<String, dynamic>> tasksJson =
          _assignedTaskToUser.map((task) => task.toJson()).toList();
      return jsonEncode(tasksJson);
    }
    return "";
  }

  Future<String> _getUserName() async {
    try {
      var userResponse = await SPHelper().getUser();
      String name =
          userResponse != null ? userResponse.users![0].staffName! : "";
      return name;
    } catch (e) {
      return "";
    }
  }
}
