import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/viewmodel/new_task/new_task_dashboard_viewmodel.dart';
import 'package:tmbi/viewmodel/new_task/new_task_detail_task_viewmodel.dart';

import '../../widgets/new_task/progressbar.dart';
import '../../widgets/new_task/section_header.dart';
import '../../widgets/new_task/sub_task_item.dart';

/*

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  static Widget create(int index) {
    return ChangeNotifierProvider(
      create: (_) => NewTaskDetailTaskViewmodel(index: index),
      child: TaskDetailsScreen(taskIndex: index),
    );
  }


  @override
  Widget build(BuildContext context) {
    final task = Provider.of<NewTaskDashboardViewmodel>(context).task;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(task.title),
            ),
          ),

          // Task Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Assigned to ${task.assignee}"),
                  Text(task.dateRange),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Overall Progress",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${task.progress}% Complete"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ProgressBar(progress: task.progress / 100),
                ],
              ),
            ),
          ),

          SectionHeader(title: "Sub-tasks (${task.subtasks.where((s) => s.completed).length}/${task.subtasks.length})"),

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
*/
class TaskDetailsScreen extends StatelessWidget {
  final int taskIndex;

  const TaskDetailsScreen({super.key, required this.taskIndex});

  static Widget create(int index) {
    return ChangeNotifierProvider(
      create: (_) => NewTaskDetailTaskViewmodel(index: index),
      child: TaskDetailsScreen(taskIndex: index),
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

    final task = vm.task;   // <-- Correct viewmodel

    return Scaffold(
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(task.title),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Assigned to ${task.assignee}"),
                  Text(task.dateRange),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Overall Progress",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${task.progress}% Complete"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ProgressBar(progress: task.progress / 100),
                ],
              ),
            ),
          ),

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
