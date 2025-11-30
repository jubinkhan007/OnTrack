import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/pair.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/db/dao/staff_dao.dart';
import 'package:tmbi/screens/todo/custom_dropdown.dart';

import '../../config/converts.dart';
import '../../config/sp_helper.dart';
import '../../config/strings.dart';
import '../../db/dao/staff_dao_new.dart';
import '../../models/models.dart' hide Staff;
import '../../network/ui_state.dart';
import '../../viewmodel/viewmodel.dart';
import '../../widgets/date_selection_view.dart';
import '../../widgets/widgets.dart';
import '../comment_screen.dart';
import '../inquiry_view.dart';

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
  String statusFlagName = StatusFlag.pending.name;

  // flag
  bool _isChecked = false;
  bool _isDateSelected = false;

  bool _hasToBeClear = false;

  // users for assign
  final List<Customer> users = [];

  List<Customer> filteredNewUsers = [];
  List<Customer> _addedUsers = [];
  List<Discussion> _assignedTaskToUser = [];

  // user info
  String staffId = "";

  void _searchForNewUsers(String query) {
    setState(() {
      filteredNewUsers = users
          .where((user) =>
              user.searchName.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onTextChanged(String text) {
    // Split the text by '@' to isolate the parts before and after each '@'
    final atSymbols = text.split('@');

    // Check if there's more than one '@'
    if (atSymbols.length > 1) {
      // Get the text after the last '@' symbol
      final afterLastAt = atSymbols.last.trim();

      // If the length after the last '@' is greater than or equal to 3, trigger the search
      if (afterLastAt.isNotEmpty && afterLastAt.length >= 3) {
        _searchForNewUsers(afterLastAt);
      } else {
        // If less than 3 characters after '@' or empty, clear the filtered list
        setState(() {
          filteredNewUsers.clear();
        });
      }
    } else {
      // If there is no '@' or only one '@', clear the filtered list
      setState(() {
        filteredNewUsers.clear();
      });
    }
  }

  String _selectedDate = DateTime.now().toFormattedString(format: "yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    _taskController.addListener(() {
      _onTextChanged(_taskController.text);
    });

    Provider.of<TodoViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataAndStore();
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchDataAndStore() async {
    try {
      List<Future> futures = [
        //_fetchAndStoreStaffs(),
        _fetchTodos(),
      ];
      await Future.wait(futures);
      await _fetchStaffsInfo();
      staffId = await _getUserName(isName: false);
    } catch (e) {
      showMessage(e.toString());
    }
  }

  Future<void> _fetchTodos({String vm = "INQALL_ALL"}) async {
    final inquiryViewModel = Provider.of<TodoViewModel>(context, listen: false);
    await inquiryViewModel.getInquiries(statusFlag, widget.staffId, "1");
  }

  Future<void> _fetchAndStoreStaffs() async {
    final addTaskViewModel =
        Provider.of<AddTaskViewModel>(context, listen: false);
    await addTaskViewModel.getStaffs(widget.staffId, "0", vm: "STAFF_ALL");

    if (addTaskViewModel.staffResponse != null) {
      if (addTaskViewModel.staffResponse!.staffs != null) {
        StaffDao staffDao = StaffDao();
        bool result = await staffDao
            .insertStaffsFromJson(addTaskViewModel.staffResponse!.staffs!);
        if (result) {
          debugPrint("Staff info inserted successfully");
        } else {
          debugPrint("Failed");
        }
      }
    }
  }

  /*Future<void> _fetchStaffsInfo() async {
    try {
      final staffDao = StaffDao();
      List<Staff> staffList = await staffDao.getStaffs();
      for (var staff in staffList) {
        users.add(Customer(
            id: staff.code.toString(), name: staff.name, isVerified: true));
      }
    } catch (e) {
      debugPrint("Error fetching staff data: $e");
    }
  }*/

  Future<void> _fetchStaffsInfo() async {
    try {
      final staffDao = StaffDaoNew(dio: null);
      List<Staff> staffList = await staffDao.getAllStaff();
      debugPrint(" fetching staff data: ${staffList[0].searchName}");
      for (var staff in staffList) {
        users.add(Customer(
            id: staff.userHris.toString(), name: staff.userName, isVerified: true, searchName: staff.searchName));
      }
      debugPrint(" fetching staff data: ${users[0].searchName}");
    } catch (e) {
      debugPrint("Error fetching staff data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    statusFlagName = value!.status!.name;
                    Provider.of<TodoViewModel>(context, listen: false)
                        .getInquiries(statusFlag, widget.staffId, "1");
                    debugPrint("StatusFlag::$statusFlag");

                    // test
                    Provider.of<TodoViewModel>(context, listen: false)
                        .tabSelectedFlag = 1;
                  }
                }),
          ),
          SizedBox(
            height: Converts.c12,
          ),

          /// task list
          Consumer<TodoViewModel>(builder: (context, inquiryViewModel, child) {
            if (inquiryViewModel.uiState == UiState.loading) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (inquiryViewModel.uiState == UiState.error) {
              return Expanded(
                child: ErrorContainer(
                    message: inquiryViewModel.message != null
                        ? inquiryViewModel.message!
                        : Strings.something_went_wrong),
              );
            }
            // null check
            if (inquiryViewModel.inquiries?.isEmpty ?? true) {
              return Expanded(
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
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
                  return Dismissible(
                    key: Key(inquiryResponse.id.toString()),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Colors.green,
                      // Background color for left swipe
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: Converts.c16),
                      child: const Icon(Icons.check,
                          color: Colors.white), // Icon for update on left swipe
                    ),
                    secondaryBackground: Container(
                      color: Colors.blueAccent,
                      // Background color for right swipe
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: Converts.c16),
                      child: const Icon(Icons.comment,
                          color: Colors
                              .white), // Icon for completion on right swipe
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        //  check if end date is expire
                        if (!inquiryResponse.endDate.isOverdue()) {
                          updateTodos(
                              Provider.of<InquiryCreateViewModel>(context,
                                  listen: false),
                              inquiryResponse);
                        } else {
                          showMessage(Strings.overdue);
                        }
                      } else if (direction == DismissDirection.endToStart) {
                        Navigator.pushNamed(
                          context,
                          CommentScreen.routeName,
                          arguments: inquiryResponse.id.toString(),
                        );
                      }
                      return false;
                    },
                    child: itemTodoTask(inquiryResponse, inquiryResponse.tasks,
                        (value) async {
                      //setState(() {
                      //debugPrint("CHECKED: $value");
                      //});
                      if (value) {
                        // check if end date is expire
                        if (!inquiryResponse.endDate.isOverdue()) {
                          await updateTodos(
                              Provider.of<InquiryCreateViewModel>(context,
                                  listen: false),
                              inquiryResponse);
                        } else {
                          showMessage(Strings.overdue);
                        }
                      }
                    }),
                  );
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
        width: double.infinity,
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
            GestureDetector(
              onTap: () {
                inquiryViewModel.setIsShowed();
              },
              child: Center(
                child: Text(
                  Strings.add_task,
                  style: TextStyle(
                      fontSize: Converts.c16 , color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            inquiryViewModel.isShowed
                ? Column(children: [
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
                                return GestureDetector(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.account_circle_outlined,
                                            size: 14,
                                            color: Palette.semiTv,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Expanded(
                                            child: Text(
                                              filteredNewUsers[index]
                                                  .name
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Palette.semiTv,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    bool userAlreadyAdded = _addedUsers.any(
                                        (user) =>
                                            user.id ==
                                            filteredNewUsers[index].id);
                                    if (!userAlreadyAdded) {
                                      setState(() {
                                        _addedUsers
                                            .add(filteredNewUsers[index]);
                                      });
                                    }

                                    // Get the current text from the TextField
                                    String currentText =
                                        _taskController.text.trim();

                                    // Check if the string contains "@" and find the position of the last "@"
                                    if (currentText.contains('@')) {
                                      int lastAtIndex =
                                          currentText.lastIndexOf('@');

                                      // Get the text before the last "@" (everything before it)
                                      String textBeforeLastAt = currentText
                                          .substring(0, lastAtIndex)
                                          .trim();

                                      // Update the text in the TextField to remove the last "@sala"
                                      setState(() {
                                        _taskController.text = textBeforeLastAt;
                                        filteredNewUsers.clear();
                                      });

                                      // Move the cursor to the end of the updated text
                                      _taskController.selection =
                                          TextSelection.collapsed(
                                        offset: _taskController.text.length,
                                      );

                                      debugPrint(
                                          "Updated Text: $textBeforeLastAt");
                                    } else {
                                      debugPrint("Updated Text: No '@' found");
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
                        /*Checkbox(
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
                ),*/
                        Expanded(
                          child: TextField(
                            controller: _taskController,
                            focusNode: _focusNode,
                            maxLines: null,
                            //minLines: 5,
                            minLines: 4,
                            //textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: Strings.add_a_task,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Palette.circleColor,
                                    fontSize: Converts.c16 - 2)),
                            style: TextStyle(
                              fontSize: Converts.c20,
                              color: Colors.grey.shade700,
                            ),
                            //onEditingComplete: _addTask, // Add task on done
                            /*onEditingComplete: () async {
                      await saveTodos(inquiryViewModel);
                    },*/ // Add task on done
                          ),
                        ),

                        /// save button
                        Material(
                  color: Colors.transparent,
                  child: !(inquiryViewModel.uiState == UiState.loading)
                      ? IconButton(
                          icon: Icon(
                            Icons.send,
                            size: Converts.c24,
                            color: Palette.mainColor,
                          ),
                          onPressed: () async {
                            if (_addedUsers.isEmpty) {
                              await _showDialogWithoutMembers(
                                  context, inquiryViewModel);
                            } else {
                              await saveTodos(inquiryViewModel);
                            }
                            //String encodedTask = Uri.encodeComponent(_taskController.text);
                            //debugPrint(encodedTask);
                          },
                        )
                      : SizedBox(
                          height: Converts.c48,
                          width: Converts.c48,
                          child: Center(
                            child: SizedBox(
                              height: Converts.c16,
                              width: Converts.c16,
                              child: const CircularProgressIndicator(
                                strokeWidth:
                                    2, // Smaller stroke for a finer spinner
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Palette.tabColor),
                              ),
                            ),
                          ),
                        ),
                )
                      ],
                    ),

                    /// assigned person (if any)
                    if (_addedUsers.isNotEmpty) assignedUser(),
                    Divider(
                      color: Colors.grey.shade300,
                    ),

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
                        Expanded(
                          child: SizedBox(
                            height: Converts.c48,
                            child: FileAttachment2(
                              inquiryViewModel: inquiryViewModel,
                            ),
                          ),
                        )
                      ],
                    ),

                    /// save button
                    /*!(inquiryViewModel.uiState == UiState.loading)
                ? */
                    /*const SizedBox(
                      height: 8,
                    ),
                    ButtonCustom1(
                        btnText: Strings.save,
                        btnHeight: Converts.c48,
                        bgColor: Palette.mainColor,
                        btnWidth: double.infinity,
                        cornerRadius: 4,
                        isLoading:
                            (inquiryViewModel.uiState == UiState.loading),
                        stockColor: Palette.mainColor,
                        onTap: () async {})*/
                    /*: SizedBox(
                    height: Converts.c48,
                    width: Converts.c48,
                    child: Center(
                      child: SizedBox(
                        height: Converts.c16,
                        width: Converts.c16,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2, // Smaller stroke for a finer spinner
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Palette.tabColor),
                        ),
                      ),
                    ),
                  ),*/
                  ])
                : const SizedBox.shrink(),
          ],
        ),
      );
    });
  }


  void _getTodos() {
    Provider.of<TodoViewModel>(context, listen: false)
        .getInquiries(statusFlag, widget.staffId, "1");
  }

  /*bool _isDateOverdue(String inputDateString) {
    final dateFormat = DateFormat("d MMM, yy");
    final DateTime targetDate = dateFormat.parse(inputDateString);
    final DateTime currentDate = DateTime.now();
    return currentDate.isAfter(targetDate);
  }*/

  Future<void> updateTodos(InquiryCreateViewModel inquiryViewModel,
      InquiryResponse inquiryResponse) async {
    if (inquiryResponse.tasks.isNotEmpty) {
      Pair<Task?, String?> pair = getOwnTaskForUpdate(inquiryResponse.tasks);

      // upload files, if any are selected
      //if (imageFiles.isNotEmpty) {
      //await inquiryViewModel.saveFiles(imageFiles);
      //}
      // update inquiry
      if (pair.first != null) {
        await inquiryViewModel.updateTask(
            inquiryResponse.id.toString(),
            pair.first!.id.toString(),
            HomeFlagItem().priorities[3].id.toString(),
            "Successfully completed the task",
            widget.staffId,
            100, []);

        // check the status of the request
        if (inquiryViewModel.uiState == UiState.error) {
          showMessage("Error: ${inquiryViewModel.message}");
        } else {
          if (inquiryViewModel.isSavedInquiry != null) {
            if (inquiryViewModel.isSavedInquiry!) {
              //showMessage(Strings.data_saved_successfully);
              // refresh
              _getTodos();
            } else {
              showMessage(Strings.failed_to_save_the_data);
            }
          } else {
            showMessage(Strings.data_is_missing);
          }
        }
      } else {
        if (pair.second != null) {
          showMessage(pair.second!);
        }
      }
    }
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
    //_isFileAttached = false;

    filteredNewUsers.clear();
    _addedUsers.clear();
    _assignedTaskToUser.clear();
    //imageFiles.clear();
  }

  Widget itemTodoTask(
    InquiryResponse inquiryResponse,
    List<Task> tasks,
    ValueChanged<bool> onChanged,
  ) {
    var otherTasks = filterOtherTasks(tasks);
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 2.0,
        bottom: 2,
      ),
      child: GestureDetector(
        onTap: () {
          //debugPrint("Value:: ${inquiryResponse.attachment.count} ${statusFlagName}");
          Navigator.pushNamed(
            context,
            InquiryView.routeName,
            arguments: {
              'inquiryResponse': inquiryResponse,
              'flag': statusFlagName,
              'staffId': staffId
            },
          );
        },
        child: Material(
          //color: _isDateOverdue(inquiryResponse.endDate) && statusFlag == StatusFlag.pending.getFlag
          color: inquiryResponse.endDate.isOverdue() &&
                  statusFlag == StatusFlag.pending.getFlag
              ? Colors.red[50]
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 2,
          child: Column(
            children: [
              Row(
                children: [
                  /*Checkbox(
                    value: areAllTasksCompleted(tasks),
                    onChanged: (bool? value) {
                      onChanged(value!);
                    },
                    shape: const CircleBorder(),
                  ),*/
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                    child: SizedBox(
                      height: Converts.c32,
                      width: Converts.c32,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                              //value: 0, // 0.0 to 1.0
                              //value: _calculateTotalPercentage(inquiryResponse) /
                              value: inquiryResponse.totalTaskPercentage / 100,
                              // 0.0 to 1.0
                              strokeWidth: 2,
                              backgroundColor: Colors.grey.shade500,
                              valueColor:
                                  //_calculateTotalPercentage(inquiryResponse) == 100
                                  inquiryResponse.totalTaskPercentage == 100
                                      ? const AlwaysStoppedAnimation<Color>(
                                          Colors.green)
                                      : const AlwaysStoppedAnimation<Color>(
                                          Colors.red),
                            ),
                          ),
                          Text(
                            //"${_calculateTotalPercentage(inquiryResponse).round()}%",
                            "${inquiryResponse.totalTaskPercentage.round()}%",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Converts.c8,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Uri.decodeComponent(inquiryResponse.title),
                          style: GoogleFonts.roboto(
                              fontSize: Converts.c16,
                              color: Colors.black,
                              //fontWeight: FontWeight.bold,
                              decoration: areAllTasksCompleted(tasks)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextViewCustom(
                              text: inquiryResponse.endDate,
                              fontSize: Converts.c12,
                              tvColor: Colors.black54,
                              isBold: false,
                              isRubik: false,
                            ),
                            otherTasks.isNotEmpty
                                ? attachUsers(otherTasks)
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Converts.c8,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget attachUsers(List<Task> users) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          ...users.take(2).map((user) {
            return ClipOval(
              child: /*CachedNetworkImage(
                imageUrl:
                    "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/${user.id}/${user.id}-0.jpg",
                width: Converts.c20,
                height: Converts.c20,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(
                  Icons.account_circle,
                  size: Converts.c20,
                ),
              ),*/
                  Icon(
                Icons.account_circle_outlined,
                size: Converts.c20,
                color: Palette.mainColor,
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

  List<Task> filterOtherTasks(List<Task> tasks) {
    // filter tasks where hasAccess is false
    return tasks.where((task) => !task.hasAccess).toList();
  }

  bool areAllTasksCompleted(List<Task> tasks) {
    // check if all tasks have hasAccess set to true
    return tasks.every((task) => task.isUpdated);
  }

  bool hasOwnTask(List<Task> tasks) {
    // check if all tasks have hasAccess set to true
    return tasks.every((task) => task.isUpdated);
  }

  Pair<Task?, String?> getOwnTaskForUpdate(List<Task> tasks) {
    // check if there are no tasks or no tasks with access
    if (tasks.isEmpty || !tasks.any((task) => task.hasAccess)) {
      return Pair(null, "You don't have access to update other tasks.");
    }
    for (var task in tasks) {
      if (!task.hasAccess) continue;
      if (tasks.length == 1) {
        if (task.isUpdated) {
          return Pair(null, "Your task has already been completed.");
        } else {
          return Pair(task, null);
        }
      } else if (!task.isUpdated) {
        // if there are multiple tasks, provide a message about possible updating
        return Pair(task,
            "Your task is being updated, but other tasks may not be completed yet. Please check");
      }
    }
    return Pair(null, "You don't have access to update other tasks.");
  }

  Widget assignedUser() {
    return Column(
      children: [
        Divider(
          color: Colors.grey.shade300,
        ),
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
        //const Divider(),
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
    // if user assign enabled, then user own task
    // not add, else then only
    // add a logged user discussion
    if (_addedUsers.isNotEmpty) {
      for (var user in _addedUsers) {
        _assignedTaskToUser.add(Discussion(
            name: user.name,
            staffId: user.id,
            dateTime: _selectedDate,
            body: _taskController.text.toString()));
      }
    } else {
      _assignedTaskToUser.add(Discussion(
        name: name,
        staffId: widget.staffId,
        dateTime: _selectedDate,
        body: _taskController.text.isNotEmpty
            ? _taskController.text.toString()
            : '',
      ));
    }
    if (_assignedTaskToUser.isNotEmpty) {
      List<Map<String, dynamic>> tasksJson =
          _assignedTaskToUser.map((task) => task.toJson()).toList();
      return jsonEncode(tasksJson);
    }
    return "";
  }

  Future<String> _getUserName({bool isName = true}) async {
    try {
      var userResponse = await SPHelper().getUser();
      String name = userResponse != null
          ? isName
              ? userResponse.users![0].staffName!
              : userResponse.users![0].staffId!
          : "";
      return name;
    } catch (e) {
      return "";
    }
  }

/*  double _calculateTotalPercentage(InquiryResponse inquiryResponse) {
    double total = 0.0;

    if (inquiryResponse.tasks != null && inquiryResponse.tasks.isNotEmpty) {
      for (var task in inquiryResponse.tasks) {
        total += task.totalPercentage;
      }

      return total / inquiryResponse.tasks.length;
    }

    return 0.0; // Avoid NaN when task list is empty
  }*/

  /// BOTTOM VIEW \\\

  /// NETWORK CALL FOR SAVE TASK \\\
  Future<void> _saveFilesIfNeeded(
      InquiryCreateViewModel inquiryViewModel) async {
    if (inquiryViewModel.imageFiles.isNotEmpty) {
      if (inquiryViewModel.imageFiles.length > 5) {
        inquiryViewModel.imageFiles.sublist(0, 5);
      }
      await inquiryViewModel.saveFiles(inquiryViewModel.imageFiles);
    }
  }

  Future<void> _saveInquiry(InquiryCreateViewModel inquiryViewModel,
      String task, String loggedUserName) async {
    String encodedTask = Uri.encodeComponent(task);
    String companyId = "0";
    String inquiryId = "0";
    String priorityId = "401";
    String customerId = "0";
    String customerName = "Other";
    String isSample = "N";

    await inquiryViewModel.saveInquiry(
        companyId,
        inquiryId,
        encodedTask,
        encodedTask,
        isSample,
        _selectedDate,
        priorityId,
        customerId,
        customerName,
        widget.staffId,
        _createAssignTaskForUsers(loggedUserName),
        inquiryViewModel.files);
  }

  Future<void> saveTodos(InquiryCreateViewModel inquiryViewModel) async {
    if (_taskController.text.isNotEmpty) {
      String loggedUserName = await _getUserName();

      // save files if necessary
      await _saveFilesIfNeeded(inquiryViewModel);

      // save the inquiry
      await _saveInquiry(
          inquiryViewModel, _taskController.text, loggedUserName);

      // check the status of the inquiry save request
      if (inquiryViewModel.isSavedInquiry == null) {
        showMessage(Strings.data_is_missing);
      } else if (inquiryViewModel.isSavedInquiry == false) {
        showMessage(Strings.failed_to_save_the_data);
      } else {
        // if saved successfully, reset fields and refresh
        setState(() {
          resetFields();
          inquiryViewModel.clearImages();
          inquiryViewModel.removeFiles();
        });

        // refresh todos after saving
        _getTodos();
      }
    } else {
      showMessage("Task description cannot be empty.");
    }
  }

  Future<void> _showDialogWithoutMembers(
      BuildContext context, InquiryCreateViewModel inquiryViewModel) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text('No team members added—are you sure?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close the dialog first
              await saveTodos(inquiryViewModel); // Call API
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
