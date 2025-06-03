import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/screens/dialog/update_task_dialog.dart';
import 'package:tmbi/screens/note_screen.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/strings.dart';
import '../models/models.dart';
import '../screens/attachment_view_screen.dart';
import '../viewmodel/add_task_viewmodel.dart';
import '../viewmodel/inquiry_viewmodel.dart';

class TaskList extends StatefulWidget {
  final Task task;
  final String inquiryId;
  final String endDate;
  final bool isOwner;
  final String? ownerId;

  const TaskList(
      {super.key,
      required this.task,
      required this.inquiryId,
      this.isOwner = false,
      this.ownerId,
      required this.endDate});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  double _currentDiscreteSliderValue = 60;

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdateTaskDialog(
            task: widget.task,
            inquiryId: widget.inquiryId,
            onCall: (hasUpdate, flag) {
              setState(() {
                widget.task.status = flag;
                widget.task.isUpdated = hasUpdate;
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.task.hasAccess
            ? widget.task.isUpdated
                ? Colors.green.withOpacity(0.1)
                : Colors.purple.withOpacity(0.1)
            : widget.task.isUpdated
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      //color: Colors.green,
      margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// menu
          /*widget.task.hasAccess | widget.isOwner
              ? Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    // Allows padding to be tappable
                    onTapDown: (TapDownDetails details) {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                          0,
                          0,
                        ),
                        items: [
                          const PopupMenuItem(
                              value: 'forward', child: Text('Forward')),
                          //const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        ],
                      ).then((value) {
                        if (value == 'forward') {
                          if (context.mounted) {
                            debugPrint('Forward tapped');
                            _showCustomerDialog(
                              context,
                              Provider.of<InquiryViewModel>(context,
                                  listen: false),
                            );
                          }
                        } */ /*else if (value == 'edit') {
                    print('Edit tapped');
                  }*/ /*
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8), // Increase tap area
                      child: Icon(
                        Icons.more_vert,
                        size: Converts.c16 - 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),*/
        /// title & status
          Row(
            children: [
              Expanded(
                child: TextViewCustom(
                    text: widget.task.name,
                    fontSize: Converts.c16,
                    tvColor: Palette.normalTv,
                    isTextAlignCenter: false,
                    isRubik: false,
                    isBold: true),
              ),
              Container(
                decoration: BoxDecoration(
                  color: widget.task.status.statusColor,
                  // Set your desired background color here
                  borderRadius: BorderRadius.circular(
                      Converts.c12), // Adjust the radius for roundness
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: TextViewCustom(
                    text: widget.task.status,
                    fontSize: Converts.c12,
                    tvColor: Colors.black,
                    isTextAlignCenter: false,
                    isRubik: false,
                    isBold: true),
              ),
            ],
          ),

          /// completer name
          Row(
            children: [
              Icon(
                Icons.account_circle,
                color: Colors.blue,
                size: Converts.c20,
              ),
              SizedBox(
                width: Converts.c8,
              ),
              Expanded(
                child: TextViewCustom(
                  text: widget.task.assignedPerson,
                  fontSize: Converts.c16,
                  tvColor: Colors.blue,
                  isTextAlignCenter: false,
                  isBold: true,
                ),
              ),
            ],
          ),

          /// date
          Row(
            children: [
              Icon(
                Icons.date_range,
                color: Palette.semiTv,
                size: Converts.c20,
              ),
              SizedBox(
                width: Converts.c8,
              ),
              TextViewCustom(
                text: widget.task.date,
                fontSize: Converts.c16,
                tvColor: Palette.semiTv,
                isTextAlignCenter: false,
                isBold: false,
              ),
            ],
          ),
          SizedBox(
            height: Converts.c16,
          ),

          /// TEST

          /*Row(
            children: [
              Expanded(
                flex: 30, // 30% green
                child: Container(
                  height: 2,
                  color: Colors.green,
                ),
              ),
              Expanded(
                flex: 70, // 70% white
                child: Container(
                  height: 2,
                  color: Colors.red,
                ),
              ),
            ],
          ),
*/
          /// flag & icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // flag
              Row(
                children: [
                  ButtonCircularIcon(
                      height: Converts.c24,
                      width: Converts.c96,
                      radius: 4,
                      /*bgColor: widget.task.hasAccess
                          ? widget.task.isUpdated
                              ? Colors.green
                              : Colors.purple
                          : widget.task.isUpdated
                              ? Colors.green
                              : Palette.iconColor,*/
                      bgColor: widget.task.hasAccess
                          ? widget.task.isUpdated
                              ? Colors.green
                              //: widget.endDate.isOverdue() ? Palette.iconColor : Colors.purple
                              : formatWithCurrentYear(widget.task.date)
                                      .isOverdue()
                                  ? Palette.iconColor
                                  : Colors.purple
                          : widget.task.isUpdated
                              ? Colors.green
                              : Palette.iconColor,
                      hasOpacity: false,
                      tvColor: Colors.white,
                      fontSize: 14,
                      /*text: widget.task.hasAccess
                          ? widget.task.isUpdated
                              ? "Complete"
                              : "Update"
                          : widget.task.isUpdated
                              ? "Complete"
                              : "Pending",*/
                      text: widget.task.hasAccess
                          ? widget.task.isUpdated
                              ? "Complete"
                              //: widget.endDate.isOverdue() ? "Expired" : "Update"
                              : formatWithCurrentYear(widget.task.date)
                                      .isOverdue()
                                  ? "Expired"
                                  : "Update"
                          : widget.task.isUpdated
                              ? "Complete"
                              //: widget.endDate.isOverdue() ? "Expired" :"Pending",
                              : formatWithCurrentYear(widget.task.date)
                                      .isOverdue()
                                  ? "Expired"
                                  : "Pending",
                      onTap: () {
                        //if (widget.task.hasAccess && !widget.task.isUpdated) {
                        if (widget.task.hasAccess &&
                            !widget.task.isUpdated &&
                            !widget.endDate.isOverdue()) {
                          _showDialog(context);
                        }
                      }),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  ButtonCircularIcon(
                      height: Converts.c24,
                      width: Converts.c96,
                      radius: 4,
                      bgColor: Colors.black,
                      hasOpacity: false,
                      tvColor: Colors.white,
                      fontSize: 14,
                      iconData: Icons.flag_outlined,
                      text: widget.task.date.split("To")[1].trim(),
                      onTap: () {}),
                ],
              ),
              // icon
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NoteScreen.routeName,
                        arguments: {
                          'inquiryId': widget.inquiryId.toString(),
                          'taskId': widget.task.id.toString(),
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Converts.c16,
                        right: Converts.c8,
                        top: Converts.c8,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          // Background color of the circle (customize as needed)
                          shape: BoxShape
                              .circle, // This makes the container circular
                        ),
                        padding: EdgeInsets.all(Converts.c8),
                        // Padding around the icon inside the circle
                        child: Icon(
                          Icons.note,
                          color: Colors.white,
                          // Color of the icon (customize as needed)
                          size: Converts.c20, // Icon size (customize as needed)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Converts.c8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AttachmentViewScreen.routeName,
                        arguments: {
                          'inquiryId': widget.inquiryId.toString(),
                          'taskId': widget.task.id.toString(),
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Converts.c8,
                        right: Converts.c8,
                        top: Converts.c8,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          // Background color of the circle (customize as needed)
                          shape: BoxShape
                              .circle, // This makes the container circular
                        ),
                        padding: EdgeInsets.all(Converts.c8),
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                          size: Converts.c20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCustomerDialog(
    BuildContext context,
    InquiryViewModel inquiryViewModel,
    /*String selectedFlagValue*/
  ) {
    getStaffs().then((staffResponse) {
      if (staffResponse != null && context.mounted) {
        List<Customer> customers = [];
        for (var staff in staffResponse!.staffs!) {
          customers.add(
              Customer(id: staff.code, name: staff.name, isVerified: false));
        }
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
                    hintName: "",
                    onCustomerSelected: (customer) async {
                      if (customer != null) {
                        setState(() {
                          //this.customer = customer;
                          widget.task.assignedPerson = customer.name!;
                        });
                        /*await _getInquiries(inquiryViewModel, selectedFlagValue,
                            isAssigned, customer!.id!);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }*/
                      }
                    }),
              );
            });
      }
    });
  }

  Future<StaffResponse?> getStaffs() async {
    await context
        .read<AddTaskViewModel>()
        .getStaffs(widget.ownerId ?? "", "0", vm: "SSEARCH");
    return mounted ? context.read<AddTaskViewModel>().staffResponse : null;
  }

  String formatWithCurrentYear(String dateRange) {
    final parts = dateRange.split("To");
    if (parts.length == 2) {
      final endDate = parts[1].trim(); // e.g., "05 Jun"

      // Get last two digits of the current year
      final int currentYear = DateTime.now().year;
      final String yearSuffix = currentYear.toString().substring(2); // "25"

      return "$endDate, $yearSuffix"; // e.g., "05 Jun, 25"
    }
    return "";
  }
}
