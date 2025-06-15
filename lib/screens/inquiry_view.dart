import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/screens/screens.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../models/models.dart';
import '../viewmodel/add_task_viewmodel.dart';
import '../widgets/widgets.dart';

class InquiryView extends StatefulWidget {
  static const String routeName = '/inquiry_screen';
  final InquiryResponse inquiryResponse;
  final String flag;
  final String staffId;

  const InquiryView(
      {super.key,
      required this.inquiryResponse,
      required this.flag,
      required this.staffId});

  @override
  State<InquiryView> createState() => _InquiryViewState();

}

class _InquiryViewState extends State<InquiryView> {
  int _countPendingTask() {
    int count = 0;
    for (var value in widget.inquiryResponse.tasks) {
      if (value.isUpdated) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Palette.mainColor,
            title: TextViewCustom(
              text: Strings.inquiry_view,
              fontSize: Converts.c20,
              tvColor: Colors.white,
              isTextAlignCenter: false,
              isBold: true,
            ),
            floating: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              // Customize icon color
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
            /*actions: [
              widget.staffId == widget.inquiryResponse.postedBy!.staffId
                  ? Row(
                      children: [
                        *//*Icon(
                          Icons.add,
                          color: Colors.white,
                          size: Converts.c12,
                        ),*//*
                        IconButton(
                          onPressed: () {
                            _showCustomerDialog(
                              context,
                            );
                          },
                          icon: const Icon(
                            Icons.supervisor_account,
                            color: Colors.white,
                          ),
                          *//*child: Text(
                            Strings.add_staff,
                            style: TextStyle(
                              fontSize: Converts.c12,
                              color: Colors.white, // Customize text color
                              fontWeight:
                                  FontWeight.bold, // Optional, for emphasis
                            ),
                          ),*//*
                        ),
                        //IconButton(
                        //onPressed: () {
                        //_showCustomerDialog(context, );
                        //_showEditDialog(context);
                        //},
                        //icon: const Icon(Icons.edit, color: Colors.white,),
                        *//*child: Text(
                            Strings.add_staff,
                            style: TextStyle(
                              fontSize: Converts.c12,
                              color: Colors.white, // Customize text color
                              fontWeight:
                                  FontWeight.bold, // Optional, for emphasis
                            ),
                          ),*//*
                        //),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],*/
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: Converts.c16,
              right: Converts.c16,
              top: Converts.c16,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _iconView(Icons.folder_open_outlined, "${Strings.project}:",
                      widget.inquiryResponse.title),
                  const SizedBox(
                    height: 4,
                  ),
                  _iconView(Icons.account_circle_outlined, "${Strings.owner}:",
                      "${widget.inquiryResponse.postedBy.name} [${widget.inquiryResponse.customer.name}]"),
                  const SizedBox(
                    height: 4,
                  ),
                  _iconView(Icons.note_outlined, "${Strings.overview}:", ""),
                  const SizedBox(
                    height: 4,
                  ),
                  TextViewCustom(
                    text: widget.inquiryResponse.description,
                    fontSize: Converts.c16,
                    tvColor: Palette.normalTv,
                    isTextAlignCenter: false,
                    isBold: false,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  _iconView(Icons.timer_outlined, "${Strings.date}:",
                      widget.inquiryResponse.endDate),
                  const SizedBox(
                    height: 4,
                  ),
                  if (widget.inquiryResponse.company != null)
                    _iconView(Icons.label_outline, "${Strings.company}:",
                        widget.inquiryResponse.company!),
                  SizedBox(
                    height: Converts.c20,
                  ),
                  Row(
                    children: [
                      ButtonCircularIcon(
                          height: Converts.c32,
                          width: Converts.c104,
                          radius: 8,
                          //bgColor: flag == HomeFlagItem().homeFlagItems[3].title
                          bgColor: widget.flag ==
                                  HomeFlagItem().homeFlagItems[1].title
                              ? Colors.green
                              : Palette.iconColor,
                          hasOpacity: false,
                          text: widget.flag,
                          fontSize: Converts.c16,
                          tvColor: Colors.white,
                          onTap: () {}),
                      SizedBox(
                        width: Converts.c8,
                      ),

                      /// show image
                      ButtonCircularIcon(
                          height: Converts.c32,
                          width: Converts.c152,
                          radius: 8,
                          bgColor: Colors.purple,
                          hasOpacity: false,
                          text: Strings.attachment,
                          fontSize: Converts.c16,
                          iconData: Icons.image,
                          tvColor: Colors.white,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AttachmentViewScreen.routeName,
                              arguments: {
                                'inquiryId':
                                    widget.inquiryResponse.id.toString(),
                                'taskId': "0",
                              },
                            );
                          }),
                      SizedBox(
                        width: Converts.c8,
                      ),

                      /// comment
                      ButtonCircularIcon(
                          height: Converts.c32,
                          width: Converts.c152,
                          radius: 8,
                          bgColor: Colors.blueAccent,
                          hasOpacity: false,
                          text: Strings.comment,
                          fontSize: Converts.c16,
                          iconData: Icons.comment,
                          tvColor: Colors.white,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              CommentScreen.routeName,
                              arguments: widget.inquiryResponse.id.toString(),
                            );
                          }),
                    ],
                  ),
                  SizedBox(
                    height: Converts.c20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextViewCustom(
                        text: Strings.tasks,
                        fontSize: Converts.c20,
                        tvColor: Colors.black,
                        isTextAlignCenter: false,
                        isRubik: false,
                        isBold: true,
                      ),
                      ButtonCircularIcon(
                          height: Converts.c32,
                          width: Converts.c40,
                          radius: 8,
                          bgColor: Palette.tabColor,
                          hasOpacity: false,
                          text:
                              "${_countPendingTask()}/${widget.inquiryResponse.tasks.length}",
                          fontSize: Converts.c12,
                          tvColor: Colors.white,
                          isTvBold: true,
                          onTap: () {})
                    ],
                  ),
                  SizedBox(
                    height: Converts.c20,
                  ),
                ],
              ),
            ),
          ),
          /*SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final task = inquiryResponse.tasks[index];
              return TaskList(
                task: task,
                inquiryId: inquiryResponse.id.toString(),
              );
            },
            childCount: inquiryResponse
                .tasks.length, // Provide the total count of items
          )),*/

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final task = widget.inquiryResponse.tasks[index];

                return /*staffId == inquiryResponse.postedBy.staffId
                    ? Dismissible (
                        key: Key(task.id.toString()),
                        // Ensure unique key
                        direction: DismissDirection.startToEnd,
                        // Right swipe
                        background: Container(
                          color: Colors.red, // Background when swiping
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          // Handle swipe action here
                          // For example: mark as done, remove item, etc.
                          print("Task ${task.id} swiped right");

                          // Optional: remove the task from the list (in stateful widgets)
                          // setState(() {
                          //   inquiryResponse.tasks.removeAt(index);
                          // });
                        },
                        child: TaskList(
                          task: task,
                          inquiryId: inquiryResponse.id.toString(),
                        ),
                      )
                    :*/
                    TaskList(
                  task: task,
                  inquiryId: widget.inquiryResponse.id.toString(),
                  isOwner:
                      widget.staffId == widget.inquiryResponse.postedBy.staffId,
                  ownerId: widget.staffId,
                  endDate: widget.inquiryResponse.endDate,
                  tasks: widget.inquiryResponse.tasks,
                );
              },
              childCount: widget.inquiryResponse.tasks.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconView(IconData icon, String text, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: Palette.normalTv,
          size: 18,
        ),
        SizedBox(
          width: Converts.c12,
        ),
        TextViewCustom(
          text: text,
          fontSize: Converts.c16,
          tvColor: Palette.normalTv,
          isBold: true,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: TextViewCustom(
            text: title,
            fontSize: Converts.c16,
            tvColor: Palette.normalTv,
            isTextAlignCenter: false,
            isBold: false,
          ),
        ),
      ],
    );
  }

  /*void _showCustomerDialog(
    BuildContext context,
    //InquiryViewModel inquiryViewModel,
    *//*String selectedFlagValue*//*
  ) {
    getStaffs(context).then((staffResponse) {
      if (staffResponse != null && context.mounted) {
        List<Customer> customers = [];
        for (var staff in staffResponse.staffs!) {
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
                        debugPrint("Name::${customer.name}");
                        setState(() {
                          var newTask =
                              widget.inquiryResponse.tasks[0].copyWith(
                            hasAccess: false,
                            isUpdated: false,
                            assignedPerson: customer.name!,
                            status: "New Entry",
                          );
                          widget.inquiryResponse.tasks.add(newTask);
                        });
                        //this.customer = customer;
                        //widget.task.assignedPerson = customer.name!;
                      }
                    }),
              );
            });
      }
    });
  }*/

/*  _showEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditTaskDialog(
            //inquiryResponse: widget.inquiryResponse,
            inquiryResponse: widget.inquiryResponse,
            onSave: (description, date, data, isUpdateAll) {
              setState(() {
                widget.inquiryResponse.description =description;
                widget.inquiryResponse.title = description;
                widget.inquiryResponse.endDate = date.toFormattedDate();
                for (var task in widget.inquiryResponse.tasks) {
                  task.name = description;
                  task.date = "${task.date.split("To")[0]} To ${date.toFormattedDate().split(",")[0]}";
                }
                //widget.task.status = flag;
                //widget.task.isUpdated = hasUpdate;
              });
            },
          );
        });
  }*/

  Future<StaffResponse?> getStaffs(BuildContext context) async {
    await context
        .read<AddTaskViewModel>()
        .getStaffs(widget.staffId, "0", vm: "SSEARCH");
    return context.mounted
        ? context.read<AddTaskViewModel>().staffResponse
        : null;
  }


}
