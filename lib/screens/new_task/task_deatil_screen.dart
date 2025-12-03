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
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/new_task/task_details_repo.dart';
import 'package:tmbi/widgets/error_container.dart';

import '../../config/strings.dart';
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
        content: Text(message),                   // The message to show
        duration: const Duration(seconds: 3),           // Duration for which the snackbar will be shown
        backgroundColor: Colors.black,            // Background color of the snackbar
        action: SnackBarAction(
          label: 'UNDO',                          // Action text
          onPressed: () {
            // Add your action logic here, e.g. undo a change
            print('Undo action triggered!');
          },
        ),
      ),
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
            body: CustomScrollView(
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
                        Row(
                          children: [
                            /*index == 0 // 0 = assign to, 1 = assign by
                                ? const Text(Strings.assignedTo)
                                : const Text(Strings.assignedBy),*/
                            Expanded(
                              child: Text(
                                " $assignName",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                                " • ${provider.mainTaskResponse!.data.first.date}"),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                      "Sub-tasks (${task.data.where((s) => s.totalCompletion == "100").length}/${task.data.first.tasks.length})",
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return SubTaskItem(subtask: task.data.first.tasks[index],
                      staffId: staffId,
                        onUpdate: (id) async {
                          await provider.updateTask(taskId, task.data.first.tasks[index].id, "7", "done", staffId, 100, []);

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
                          }
                        },
                      );
                    },
                    childCount: task.data.first.tasks.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

  }
}
