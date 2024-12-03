import 'package:flutter/material.dart';
import 'package:tmbi/models/models.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/strings.dart';
import '../widgets/date_selection_view.dart';
import '../widgets/widgets.dart';

class AddTaskToStaffScreen extends StatefulWidget {
  static const String routeName = '/add_task_to_staff_screen';
  final String staffId;
  final List<Discussion> tasks;

  const AddTaskToStaffScreen(
      {super.key, required this.staffId, required this.tasks});

  @override
  State<AddTaskToStaffScreen> createState() => _AddTaskToStaffScreenState();
}

class _AddTaskToStaffScreenState extends State<AddTaskToStaffScreen> {
  final TextEditingController descriptionController = TextEditingController();
  String selectedDate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.mainColor,
        title: TextViewCustom(
          text: Strings.add_task,
          fontSize: Converts.c20,
          tvColor: Colors.white,
          isTextAlignCenter: false,
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(left: Converts.c16, right: Converts.c16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  /// task title
                  SizedBox(
                    height: Converts.c16,
                  ),
                  TextFieldInquiry(
                    fontSize: Converts.c16,
                    fontColor: Palette.normalTv,
                    hintColor: Palette.semiTv,
                    hint: Strings.what_is_the_task,
                    controller: descriptionController,
                    maxLine: 3,
                    hasBorder: true,
                  ),

                  /// date
                  SizedBox(
                    height: Converts.c8,
                  ),
                  DateSelectionView(
                    onDateSelected: (date) {
                      if (date != null) {
                        selectedDate = date;
                      }
                    },
                    hint: Strings.select_end_date,
                  ),

                  /// account
                  SizedBox(
                    height: Converts.c8,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            color: Palette.semiTv,
                            size: Converts.c32,
                          ),
                          SizedBox(
                            width: Converts.c8,
                          ),
                          TextViewCustom(
                              text: "MD. AKASH ALAM",
                              fontSize: Converts.c16,
                              tvColor: Palette.normalTv,
                              isRubik: false,
                              isBold: true),
                        ],
                      ),
                      SizedBox(
                        width: Converts.c16,
                      ),
                      Container(
                        width: Converts.c48,
                        height: Converts.c48,
                        decoration: BoxDecoration(
                          //color: Palette.mainColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(Converts.c24),
                          ),
                          border: Border.all(
                            color: Palette.mainColor, // Border color
                            width: 1.0, // Border width
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          size: Converts.c16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  /// button
                  SizedBox(
                    height: Converts.c16,
                  ),
                  ButtonCustom1(
                      btnText: Strings.add_task,
                      btnHeight: Converts.c48,
                      bgColor: Palette.mainColor,
                      btnWidth: Converts.c160,
                      cornerRadius: 4,
                      stockColor: Palette.mainColor,
                      onTap: () async {}),
                ],
              ),
            ),
          ),
          widget.tasks.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    var task = widget.tasks[index];
                    return IndividualTaskList(task: task);
                  }, childCount: widget.tasks.length),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
