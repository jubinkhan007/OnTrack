import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/viewmodel/new_task/new_task_dashboard_viewmodel.dart';

import '../../config/converts.dart';
import '../../widgets/new_task/app_header.dart';
import '../../widgets/new_task/filter_section.dart';
import '../../widgets/new_task/status_cards.dart';
import '../../widgets/new_task/tab_selector.dart';
import '../../widgets/new_task/task_item.dart';
import '../todo/todo_home_screen.dart';

class NewTaskDashboardScreen extends StatelessWidget {
  static const String routeName = '/new_task_dashboard_screen';

  const NewTaskDashboardScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => NewTaskDashboardViewmodel(),
      child: const NewTaskDashboardScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NewTaskDashboardViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, TodoHomeScreen.routeName,
              arguments: "340553");
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- App Bar --- \\
            const SliverToBoxAdapter(
              child: AppHeader(),
            ),
            // --- Tab Selector# Created By Me | Assigned To me -- \\
            SliverToBoxAdapter(
              child: SizedBox(
                height: Converts.c12,
              ),
            ),
            SliverToBoxAdapter(
              child: TabSelector(
                createdSelected: vm.selectedTab == 0,
                onCreatedTap: () => vm.changeTab(0),
                onAssignedTap: () => vm.changeTab(1),
              ),
            ),
            // --- Filter# BU wise | Staff name \\
            SliverToBoxAdapter(
              child: FilterSection(
                selectedBU: vm.selectedBU,
                buOptions: vm.buOptions,
                staffName: vm.staffName,
                onBUChanged: (value) => vm.changeBU(value!),
                onStaffChanged: (value) => vm.changeStaff(value),
              ),
            ),
            // --- Count Card View --- \\
            SliverToBoxAdapter(
              child: StatusCards(
                pending: vm.pending,
                overdue: vm.overdue,
                completed: vm.completed,
              ),
            ),
            // --- Tab Menu --- \\
            SliverToBoxAdapter(
              child: SizedBox(
                height: Converts.c12,
              ),
            ),
            SliverToBoxAdapter(
              child: _tabMenu(vm),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final task = vm.currentTasks[index];
                  return TaskItem(
                    title: task["title"]!,
                    staff: task["staff"]!,
                    completionText: task["completion"]!,
                    completionColor: task["completion"] == "100% Complete"
                        ? Colors.green
                        : task["completion"] == "0% Complete"
                            ? Colors.red
                            : Colors.orange,
                  );
                },
                childCount: vm.currentTasks.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabMenu(NewTaskDashboardViewmodel vm) {
    List<String> tabs = ["All", "Pending", "Overdue", "Completed"];

    return Container(
      margin: EdgeInsets.symmetric(vertical: Converts.c12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          tabs.length,
          (index) => GestureDetector(
            onTap: () => vm.changeTab(index),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontWeight:
                    vm.selectedTab == index ? FontWeight.bold : FontWeight.w400,
                color: vm.selectedTab == index ? Colors.blue : Colors.black54,
              ),
              child: Text(tabs[index]),
            ),
          ),
        ),
      ),
    );
  }
}
