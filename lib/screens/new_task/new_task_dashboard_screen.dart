import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/viewmodel/new_task/new_task_dashboard_viewmodel.dart';

import '../../config/converts.dart';
import '../../config/sp_helper.dart';
import '../../config/strings.dart';
import '../../widgets/new_task/app_header.dart';
import '../../widgets/new_task/filter_section.dart';
import '../../widgets/new_task/status_cards.dart';
import '../../widgets/new_task/tab_selector.dart';
import '../../widgets/new_task/task_item.dart';
import '../login_screen.dart';
import '../todo/todo_home_screen.dart';

class NewTaskDashboardScreen extends StatelessWidget {
  static const String routeName = '/new_task_dashboard_screen';
  final String staffId;

  const NewTaskDashboardScreen({super.key, required this.staffId});

  static Widget create(String staffId) {
    return ChangeNotifierProvider(
      create: (_) => NewTaskDashboardViewmodel(),
      child: NewTaskDashboardScreen(
          staffId: staffId), // Pass staffId to the constructor
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
              arguments: staffId);
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- App Bar --- \\
            SliverToBoxAdapter(
              child: AppHeader(
                onLogoutTap: () {
                  _showLogoutDialog(context);
                },
                onNotificationTap: () {},
              ),
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

  Future<void> _showLogoutDialog(BuildContext context) async {
    bool? logoutConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.logout),
          content: const Text(Strings.are_you_sure_you_want_to_logout),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // return false to indicate cancellation
              },
              child: const Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () async {
                await SPHelper().removeUser();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) =>
                    false, // Removes all previous routes
                  );
                }
              },
              child: const Text(Strings.yes),
            ),
          ],
        );
      },
    );
  }

}
