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

  const AddTaskToStaffScreen({super.key, required this.staffId, required this.tasks});

  @override
  State<AddTaskToStaffScreen> createState() => _AddTaskToStaffScreenState();
}

class _AddTaskToStaffScreenState extends State<AddTaskToStaffScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final List<Discussion> newTasks = [];
  String selectedDate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.tasks.isNotEmpty) {
      newTasks.addAll(widget.tasks);
    }
  }

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
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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

                      /// add task
                      ButtonCustom1(
                          btnText: Strings.add,
                          btnHeight: Converts.c48,
                          bgColor: Palette.mainColor,
                          btnWidth: Converts.c120,
                          cornerRadius: 4,
                          stockColor: Palette.mainColor,
                          onTap: () async {
                            setState(() {
                              newTasks.add(Discussion(
                                  name: "Md. Salauddin", staffId: "340553", dateTime: "2024-04-12, 10:42 AM", body: descriptionController.text
                              ));
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          newTasks.isNotEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: Converts.c16,
                      right: Converts.c16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Converts.c16,
                        ),
                        const TextViewCustom(
                            text: Strings.task_distribution_for_employees,
                            fontSize: 16,
                            tvColor: Palette.iconColor,
                            isRubik: false,
                            isBold: true),
                      ],
                    ),
                  ),
                )
              : const SliverToBoxAdapter(),
          SliverPadding(
            padding: EdgeInsets.only(
              left: Converts.c16,
              right: Converts.c16,
            ),
            sliver: SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                var task = newTasks[index];
                return IndividualTaskList(task: task);
              }, childCount: newTasks.length),
            ),
          ),
        ],
      ),
    );
  }
}
