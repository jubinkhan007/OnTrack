/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/models/new_task/task_response.dart';
import 'package:tmbi/repo/new_task/task_details_repo.dart';
import 'package:tmbi/viewmodel/new_task/new_task_detail_task_viewmodel.dart';

import '../../config/strings.dart';
import '../../network/api_service.dart';
import '../../viewmodel/new_task/task_details_viewmodel.dart';
import '../../widgets/new_task/progressbar.dart';
import '../../widgets/new_task/section_header.dart';
import '../../widgets/new_task/sub_task_item.dart';

class TaskDetailsScreen extends StatelessWidget {
  final int taskIndex;
  final Task task2;

  const TaskDetailsScreen(
      {super.key, required this.taskIndex, required this.task2});

  //static Widget create(int index, Task task) {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //create: (_) => NewTaskDetailTaskViewmodel(index: index),
      create: (_) => TaskDetailsViewmodel(
        taskDetailsRepo: TaskDetailsRepo(
            dio:
                ApiService("https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
      ),
      child: */
/*TaskDetailsScreen(
        taskIndex: index,
        task2: task,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NewTaskDetailTaskViewmodel>(context);

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final task = vm.task;*/ /*


    //return
      Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<TaskDetailsViewmodel>(
          builder: (context, provider, _) {
          //? const Center(child: CircularProgressIndicator()):
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(
                    Strings.task_details,
                    style: TextStyle(fontSize: Converts.c16),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.redAccent,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //task.title,
                          task2.name,
                          style: TextStyle(
                              fontSize: Converts.c16 + 2,
                              color: Colors.blue,
                              fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: [
                            const Text(Strings.assignedTo),
                            Expanded(
                              child: Text(
                                //"${task.assignee}",
                                " ${task2.assignToName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              //" • ${task.dateRange}",
                              " • ${task2.createdDate.split("T")[0]}",
                            ),
                          ],
                        ),
                        // --- Completion Percentage --- \\
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    Strings.overAllProgress,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  //Text("${task.progress}% ${Strings.complete}"),
                                  Text(
                                    "${task2.completion}% | ${task2.status}",
                                    style: TextStyle(
                                        color: TaskStatusFlag
                                                    .completed.getData.first ==
                                                task2.status
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              //ProgressBar(progress: task.progress / 100),
                              ProgressBar(
                                  progress:
                                      double.tryParse(task2.completion) ?? 0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Sub Tasks --- \\
                SectionHeader(
                  title:
                      "Sub-tasks (${task.subtasks.where((s) => s.completed).length}/${task.subtasks.length})",
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return SubTaskItem(subtask: task.subtasks[index]);
                    },
                    childCount: task.subtasks.length,
                  ),
                ),
              ],
            ),}
    ));
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/new_task/task_details_repo.dart';
import 'package:tmbi/widgets/error_container.dart';

import '../../config/strings.dart';
import '../../models/new_task/main_task_response.dart';
import '../../network/api_service.dart';
import '../../viewmodel/new_task/task_details_viewmodel.dart';
import '../../widgets/new_task/progressbar.dart';
import '../../widgets/new_task/section_header.dart';
import '../../widgets/new_task/sub_task_item.dart';

class TaskDetailsScreen extends StatelessWidget {
  static const String routeName = '/task_details_screen';

  final int index;
  final String taskId;
  final String staffId;
  final String assignName;

  const TaskDetailsScreen(
      {super.key,
      required this.index,
      required this.assignName,
      required this.taskId,
      required this.staffId});

  void showCustomSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        // The message to show
        duration: const Duration(seconds: 3),
        // Duration for which the snackbar will be shown
        backgroundColor: Colors.black,
        // Background color of the snackbar
        action: SnackBarAction(
          label: 'UNDO', // Action text
          onPressed: () {
            // Add your action logic here, e.g. undo a change
            debugPrint('Undo action triggered!');
          },
        ),
      ),
    );
  }

  DateTime? _tryParseDueDate(String taskDate) {
    // Task date strings usually look like: "YYYY-MM-DD - YYYY-MM-DD"
    // or other formats containing ISO dates. Use the last ISO date as due date.
    final matches = RegExp(r"\d{4}-\d{2}-\d{2}").allMatches(taskDate).toList();
    if (matches.isEmpty) return null;
    final iso = matches.last.group(0);
    if (iso == null || iso.isEmpty) return null;
    return DateTime.tryParse(iso);
  }

  Future<void> _openReminderSheet(
    BuildContext context,
    TaskDetailsViewmodel provider,
    String staffId,
    String inquiryId,
    SubTask subTask,
  ) async {
    final now = DateTime.now();
    final dueDate = _tryParseDueDate(subTask.date);
    final dueMorning = dueDate == null
        ? null
        : DateTime(dueDate.year, dueDate.month, dueDate.day, 9, 0);
    final dayBeforeDueMorning =
        dueMorning == null ? null : dueMorning.subtract(const Duration(days: 1));

    DateTime laterToday = DateTime(now.year, now.month, now.day, 18, 0);
    if (!laterToday.isAfter(now)) {
      laterToday = DateTime(now.year, now.month, now.day + 1, 9, 0);
    }

    final tomorrow9 = DateTime(now.year, now.month, now.day + 1, 9, 0);
    final nextWeek9 = DateTime(now.year, now.month, now.day + 7, 9, 0);

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dayBeforeDueMorning != null &&
                  dayBeforeDueMorning.isAfter(now.add(const Duration(seconds: 5))))
                ListTile(
                  leading: const Icon(Icons.notifications_none),
                  title: const Text("1 day before due date"),
                  subtitle: Text("${dayBeforeDueMorning.toLocal()}".split(".").first),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final err = await provider.setReminder(
                      staffId: staffId,
                      inquiryId: inquiryId,
                      subTask: subTask,
                      remindAt: dayBeforeDueMorning,
                    );
                    if (context.mounted) {
                      showCustomSnackbar(
                        context,
                        err ?? "Reminder set.",
                      );
                    }
                  },
                ),
              if (dueMorning != null &&
                  dueMorning.isAfter(now.add(const Duration(seconds: 5))))
                ListTile(
                  leading: const Icon(Icons.notifications_none),
                  title: const Text("On due date"),
                  subtitle: Text("${dueMorning.toLocal()}".split(".").first),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final err = await provider.setReminder(
                      staffId: staffId,
                      inquiryId: inquiryId,
                      subTask: subTask,
                      remindAt: dueMorning,
                    );
                    if (context.mounted) {
                      showCustomSnackbar(
                        context,
                        err ?? "Reminder set.",
                      );
                    }
                  },
                ),
              ListTile(
                leading: const Icon(Icons.notifications_none),
                title: const Text("Later today"),
                subtitle: Text("${laterToday.toLocal()}".split(".").first),
                onTap: () async {
                  Navigator.pop(ctx);
                  final err = await provider.setReminder(
                    staffId: staffId,
                    inquiryId: inquiryId,
                    subTask: subTask,
                    remindAt: laterToday,
                  );
                  if (context.mounted) {
                    showCustomSnackbar(
                      context,
                      err ?? "Reminder set.",
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_none),
                title: const Text("Tomorrow morning"),
                subtitle: const Text("9:00 AM"),
                onTap: () async {
                  Navigator.pop(ctx);
                  final err = await provider.setReminder(
                    staffId: staffId,
                    inquiryId: inquiryId,
                    subTask: subTask,
                    remindAt: tomorrow9,
                  );
                  if (context.mounted) {
                    showCustomSnackbar(context, err ?? "Reminder set.");
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_none),
                title: const Text("Next week"),
                subtitle: const Text("9:00 AM"),
                onTap: () async {
                  Navigator.pop(ctx);
                  final err = await provider.setReminder(
                    staffId: staffId,
                    inquiryId: inquiryId,
                    subTask: subTask,
                    remindAt: nextWeek9,
                  );
                  if (context.mounted) {
                    showCustomSnackbar(context, err ?? "Reminder set.");
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_calendar_outlined),
                title: const Text("Pick date & time"),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: now.add(const Duration(days: 1)),
                    firstDate: now,
                    lastDate: DateTime(now.year + 5),
                  );
                  if (!context.mounted) return;
                  if (pickedDate == null) return;

                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 9, minute: 0),
                  );
                  if (!context.mounted) return;
                  if (pickedTime == null) return;

                  final remindAt = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  if (ctx.mounted) Navigator.pop(ctx);
                  final err = await provider.setReminder(
                    staffId: staffId,
                    inquiryId: inquiryId,
                    subTask: subTask,
                    remindAt: remindAt,
                  );
                  if (context.mounted) {
                    showCustomSnackbar(context, err ?? "Reminder set.");
                  }
                },
              ),
              if (provider.hasReminder(subTask.id))
                ListTile(
                  leading: const Icon(Icons.notifications_off_outlined),
                  title: const Text("Remove reminder"),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await provider.clearReminder(
                      staffId,
                      inquiryId,
                      subTask.id,
                    );
                    if (context.mounted) {
                      showCustomSnackbar(context, "Reminder removed.");
                    }
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _openStatusDialog(BuildContext context, String id,
      TaskDetailsViewmodel provider, SubTask subtask) {
    int? selectedStatus = 3; // default = Pending
    TextEditingController noteController = TextEditingController();
    double? currentDiscreteSliderValue =
        double.tryParse(subtask.completion ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Update Status",
                style: TextStyle(
                    fontSize: Converts.c16, fontWeight: FontWeight.w400),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drop-down
                  DropdownButtonFormField<int>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 3,
                          child: Text("In Progress",
                              style: TextStyle(fontSize: Converts.c16 - 2))),
                      DropdownMenuItem(
                          value: 7,
                          child: Text("Completed",
                              style: TextStyle(fontSize: Converts.c16 - 2))),
                    ],
                    onChanged: (value) {
                      setState(() => selectedStatus = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  // Note TextField
                  TextField(
                    controller: noteController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: "Note",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  // percentage indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "How much done? (${currentDiscreteSliderValue!.round().toString()}/100)",
                        style: TextStyle(
                            color: currentDiscreteSliderValue!.round() > 60
                                ? currentDiscreteSliderValue!.round() == 100
                                    ? Colors.green
                                    : Colors.orangeAccent
                                : Colors.deepOrange,
                            fontSize: Converts.c12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Slider(
                    value: currentDiscreteSliderValue ?? 0.0,
                    max: 100,
                    divisions: 10,
                    label: currentDiscreteSliderValue!.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        currentDiscreteSliderValue = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    // use the data (status + note)
                    debugPrint("Status Code: $selectedStatus");
                    debugPrint("Note: ${noteController.text}");

                    final rawPct = selectedStatus == 7
                        ? "100"
                        : currentDiscreteSliderValue != null
                            ? currentDiscreteSliderValue.toString()
                            : "0";
                    final pctInt = double.tryParse(rawPct)?.round() ?? 0;
                    // If user sets 100%, force "Completed" status so it won't stay in "In Queue".
                    final effectiveStatus = pctInt >= 100 ? 7 : (selectedStatus ?? 3);
                    await provider.updateTask(
                        taskId,
                        id,
                        effectiveStatus.toString(),
                        noteController.text
                            .toString()
                            .replaceAll("%", " percent"),
                        staffId,
                        //selectedStatus == 7 ? 100 : 0,
                        pctInt >= 100 ? "100" : rawPct,
                        []);

                    if (provider.isUpdated != null) {
                      if (provider.isUpdated!) {
                        if (provider.isOfflineUpdateSaved) {
                          if (context.mounted) {
                            showCustomSnackbar(
                              context,
                              "Task update saved offline. It will sync automatically when internet is available.",
                            );
                          }
                        } else {
                          provider.getSubTasks(staffId, taskId);
                        }
                      } else {
                        if (context.mounted) {
                          showCustomSnackbar(context,
                              provider.message ?? "Something went wrong");
                        }
                      }
                    } else {
                      if (context.mounted) {
                        showCustomSnackbar(context,
                            provider.message ?? "Something went wrong");
                      }
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskDetailsViewmodel(
        taskDetailsRepo: TaskDetailsRepo(
          dio: ApiService("https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
              .provideDio(),
        ),
      )..getSubTasks(staffId, taskId),
      child: Consumer<TaskDetailsViewmodel>(
        builder: (context, provider, _) {
          if (provider.uiState == UiState.loading) {
            return Scaffold(
              body: context.shimmerLoading(),
            );
          }

          final task = provider.mainTaskResponse;

          if (task == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  Strings.task_details,
                  style: TextStyle(fontSize: Converts.c16),
                ),
                centerTitle: true,
                backgroundColor: Colors.redAccent,
              ),
              body: Center(
                  child: ErrorContainer(
                      message: provider.message ??
                          "Something went wrong, please try again.")),
            );
          }

          if (task.data.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  Strings.task_details,
                  style: TextStyle(fontSize: Converts.c16),
                ),
                centerTitle: true,
                backgroundColor: Colors.redAccent,
              ),
              body: Center(
                  child: ErrorContainer(
                      message: provider.message ?? "(no data found)")),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              onRefresh: ()=> provider.getSubTasks(staffId, taskId),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text(
                      Strings.task_details,
                      style: TextStyle(fontSize: Converts.c16),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.redAccent,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.mainTaskResponse!.data.first.mainTaskName,
                            style: TextStyle(
                              fontSize: Converts.c16 + 2,
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          assignName.withDate(
                            " • ${provider.mainTaskResponse!.data.first.date}",
                            fontSize: Converts.c16 - 2,
                          ),
                          const SizedBox(height: 4),
                          provider.mainTaskResponse!.data.first.mainTaskDetail != "null" ? Text(
                            provider.mainTaskResponse!.data.first.mainTaskDetail,
                            style: TextStyle(
                              fontSize: Converts.c16,
                              color: Colors.black87,
                              //fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                            ),
                          ) : const SizedBox.shrink(),
                          const SizedBox(height: 8),
                          /*Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      Strings.overAllProgress,
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${provider.mainTaskResponse!.data.first.totalCompletion}% | ${provider.mainTaskResponse!.data.first.status}",
                                      style: TextStyle(
                                        color: TaskStatusFlag
                                                    .completed.getData.first ==
                                                provider.mainTaskResponse!.data
                                                    .first.status
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ProgressBar(
                                  progress: double.tryParse(provider
                                          .mainTaskResponse!
                                          .data
                                          .first
                                          .totalCompletion) ??
                                      0,
                                ),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                  SectionHeader(
                    title:
                        "Sub-tasks (${task.data.first.tasks.where((s) => s.completion == "100").length}/${task.data.first.tasks.length})",
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final sub = task.data.first.tasks[index];
                        final isAssignee = sub.assignToId == staffId;
                        return SubTaskItem(
                          subtask: sub,
                          staffId: staffId,
                          reminderText: isAssignee
                              ? provider.reminderLabel(sub.id)
                              : null,
                          onReminderTap: isAssignee
                              ? () => _openReminderSheet(
                                    context,
                                    provider,
                                    staffId,
                                    taskId,
                                    sub,
                                  )
                              : null,
                          onReminderClear: isAssignee && provider.hasReminder(sub.id)
                              ? () async {
                                  await provider.clearReminder(
                                    staffId,
                                    taskId,
                                    sub.id,
                                  );
                                  if (context.mounted) {
                                    showCustomSnackbar(
                                        context, "Reminder removed.");
                                  }
                                }
                              : null,
                          onUpdate: (id) async {
                            //_openStatusDialog(context, taskId, provider);
                            _openStatusDialog(context, id, provider,
                                sub);

                            /*await provider.updateTask(taskId, task.data.first.tasks[index].id, "7", "done", staffId, 100, []);

                            if (provider.isUpdated != null) {
                              if (provider.isUpdated!) {
                                provider.getSubTasks(staffId, taskId);
                              } else {
                                if (context.mounted) {
                                  showCustomSnackbar(context, provider.message ?? "Something went wring");
                                }
                              }
                            } else {
                              if (context.mounted) {
                                showCustomSnackbar(context, provider.message ?? "Something went wring");
                              }
                            }*/
                          },
                          mainTaskId: task.data.last.mainTaskId,
                          onReturn: () => provider.getSubTasks(staffId, taskId),
                        );
                      },
                      childCount: task.data.first.tasks.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
