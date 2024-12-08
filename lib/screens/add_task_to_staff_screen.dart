import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/models/models.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/strings.dart';
import '../viewmodel/viewmodel.dart';
import '../widgets/date_selection_view.dart';
import '../widgets/widgets.dart';

class AddTaskToStaffScreen extends StatefulWidget {
  static const String routeName = '/add_task_to_staff_screen';
  final String staffId;
  final List<Discussion> tasks;
  final List<Customer> staffs;

  const AddTaskToStaffScreen({
    super.key,
    required this.staffId,
    required this.tasks,
    required this.staffs,
  });

  @override
  State<AddTaskToStaffScreen> createState() => _AddTaskToStaffScreenState();
}

class _AddTaskToStaffScreenState extends State<AddTaskToStaffScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final List<Discussion> newTasks = [];
  late InquiryCreateViewModel inquiryCreateViewModel;
  String selectedDate = "";
  Customer? customer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inquiryCreateViewModel =
        Provider.of<InquiryCreateViewModel>(context, listen: false);
    // load previous tasks if any
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
                          customer != null
                              ? Row(
                                  children: [
                                    ClipOval(
                                      child: SizedBox(
                                        width: Converts.c48,
                                        height: Converts.c48,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/${customer!.id}/${customer!.id}-0.jpg",
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              SizedBox(
                                            width: Converts.c16,
                                            height: Converts.c16,
                                            child:
                                                const CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Palette.mainColor),
                                              strokeWidth: 2.0,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) {
                                            return Icon(
                                              Icons.account_circle,
                                              color: Palette.normalTv,
                                              size: Converts.c48,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Converts.c8,
                                    ),
                                    TextViewCustom(
                                        text: (customer!.name
                                                    .toString()
                                                    .length >
                                                10)
                                            ? '${customer!.name.toString().substring(0, 10)}...'
                                            : customer!.name.toString(),
                                        fontSize: Converts.c16,
                                        tvColor: Palette.normalTv,
                                        isRubik: false,
                                        isBold: true),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          SizedBox(
                            width: Converts.c16,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showCustomerDialog(context, widget.staffs);
                            },
                            child: SizedBox(
                              width: Converts.c48,
                              height: Converts.c48,
                              child: Image.asset(
                                'assets/ic_add_user.png',
                                width: Converts.c16,
                                // You can adjust the size as needed
                                height: Converts.c16,
                              ),
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
                              context.hideKeyboard();
                              if (customer != null &&
                                  selectedDate != "" &&
                                  descriptionController.text != "") {
                                Discussion discussion = Discussion(
                                    name: customer!.name.toString(),
                                    staffId: customer!.id,
                                    dateTime: selectedDate,
                                    body: descriptionController.text);
                                newTasks.add(discussion);
                                // add tasks into viewmodel
                                inquiryCreateViewModel.addTask(discussion);
                                // reset fields
                                customer = null;
                                descriptionController.text = "";
                              } else {
                                context.showMessage(
                                    Strings.some_values_are_missing);
                              }
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
                return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      if (index >= 0 && index < newTasks.length) {
                        setState(() {
                          inquiryCreateViewModel.removeTask(index);
                          newTasks.removeAt(index);
                        });
                      }
                    },
                    child: IndividualTaskList(task: task));
              }, childCount: newTasks.length),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerDialog(BuildContext context, List<Customer> customers) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: TextViewCustom(
                text: Strings.search_by_name,
                fontSize: Converts.c16,
                tvColor: Palette.normalTv,
                isTextAlignCenter: false,
                isRubik: false,
                isBold: true),
            content: CustomerSearchDialog(
                customers: customers,
                onCustomerSelected: (customer) {
                  if (customer != null) {
                    setState(() {
                      this.customer = customer;
                    });
                  }
                  Navigator.of(context).pop();
                }),
          );
        });
  }
}
