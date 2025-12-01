import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/models/new_task/bu_response.dart';
import 'package:tmbi/repo/new_task/new_task_dashboard_repo.dart';
import 'package:tmbi/viewmodel/new_task/new_task_dashboard_viewmodel.dart';
import 'package:tmbi/widgets/error_container.dart';

import '../../config/converts.dart';
import '../../config/strings.dart';
import '../../network/api_service.dart';
import '../../network/ui_state.dart';
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
      create: (_) => NewTaskDashboardViewmodel(
        staffId: staffId,
        ntdRepo: NewTaskDashboardRepo(
            dio:
                ApiService("https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
      ),
      child: NewTaskDashboardScreen(
          staffId: staffId), // Pass staffId to the constructor
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NewTaskDashboardViewmodel>(context);

    if (vm.uiState == UiState.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                staffController: vm.staffController,
                onBUChanged: (value) => vm.changeBU(value!),
                onClean: () {
                  vm.setStaffName("");
                  vm.clearStaff();
                  vm.changeStaff("");
                },
                onStaffTap: () async {
                  await _showStaffSearchDialog(context, vm);
                },
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
            vm.tasks.isNotEmpty
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = vm.tasks[index];
                        return TaskItem(
                            //title: task.name,
                            //staff: task.assignToName,
                          task: task,
                            completionText:
                                "${task.completion}% | ${task.status}",
                            completionColor: task.status ==
                                    TaskStatusFlag.completed.getData.first
                                ? Colors.green
                                : Colors.red);
                      },
                      childCount: vm.tasks.length,
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: ErrorContainer(
                          message: vm.message ?? "Something went wrong!",
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _tabMenu(NewTaskDashboardViewmodel vm) {
    List<TaskStatusFlag> tabs = [
      TaskStatusFlag.all,
      TaskStatusFlag.pending,
      TaskStatusFlag.overdue,
      TaskStatusFlag.completed
    ];

    return Container(
      margin: EdgeInsets.symmetric(vertical: Converts.c12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          tabs.length,
          (index) => GestureDetector(
            onTap: () => vm.changeStatus(tabs[index]),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontWeight: vm.statusTab == tabs[index]
                    ? FontWeight.bold
                    : FontWeight.w400,
                color:
                    vm.statusTab == tabs[index] ? Colors.blue : Colors.black54,
              ),
              child: Text(tabs[index].getData.first),
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
                //await SPHelper().removeUser();
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

  Future<void> _showStaffSearchDialog(
      BuildContext context, NewTaskDashboardViewmodel vm) async {
    final bu = await showDialog<BusinessUnit>(
      context: context,
      builder: (_) => StaffSearchDialog(
        staffList: vm.buStaffs,
      ),
    );

    if (bu != null) {
      vm.setStaffName(bu.userName);
      vm.changeStaff(bu.userHris);
    }
  }
}

class StaffSearchDialog extends StatelessWidget {
  final List<BusinessUnit> staffList;

  StaffSearchDialog({super.key, required this.staffList});

  final ValueNotifier<String> _searchQuery = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Staff Search',
        style: TextStyle(fontSize: Converts.c16, color: Colors.black),
      ),
      content: SizedBox(
        width: double.maxFinite,
        //height: 400, // limit dialog height
        child: Column(
          children: [
            // Search TextField (using ValueNotifier)
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _searchQuery.value = val,
              autofocus: true,
            ),
            const SizedBox(height: 12),
            // List filtered reactively
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: _searchQuery,
                builder: (context, query, _) {
                  final filteredStaff = staffList.where((staff) {
                    final lowerQuery = query.toLowerCase();
                    return staff.userName.toLowerCase().contains(lowerQuery);
                  }).toList();

                  if (filteredStaff.isEmpty) {
                    return const Center(child: Text('(No staff found)'));
                  }

                  return ListView.builder(
                    itemCount: filteredStaff.length,
                    itemBuilder: (context, index) {
                      final staff = filteredStaff[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://avatar.iran.liara.run/public/32"),
                        ),
                        title: Text(staff.userName),
                        subtitle: Text(staff.displayName),
                        onTap: () =>
                            //{Navigator.of(context).pop(staff.userName)},
                            {Navigator.of(context).pop(staff)},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
