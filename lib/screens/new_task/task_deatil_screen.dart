import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/models/new_task/task_response.dart';
import 'package:tmbi/viewmodel/new_task/new_task_detail_task_viewmodel.dart';

import '../../config/strings.dart';
import '../../widgets/new_task/progressbar.dart';
import '../../widgets/new_task/section_header.dart';
import '../../widgets/new_task/sub_task_item.dart';

class TaskDetailsScreen extends StatelessWidget {
  final int taskIndex;
  final Task task2;

  const TaskDetailsScreen(
      {super.key, required this.taskIndex, required this.task2});

  static Widget create(int index, Task task) {
    return ChangeNotifierProvider(
      create: (_) => NewTaskDetailTaskViewmodel(index: index),
      child: TaskDetailsScreen(
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

    final task = vm.task;

    return Scaffold(
      backgroundColor: Colors.white,
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
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
                              ProgressBar(progress: double.tryParse(task2.completion) ?? 0),
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
            ),
    );
  }
}
