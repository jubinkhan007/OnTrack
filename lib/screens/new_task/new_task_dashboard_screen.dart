import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/models/new_task/bu_response.dart';
import 'package:tmbi/repo/new_task/new_task_dashboard_repo.dart';
import 'package:tmbi/screens/new_task/sync_screen.dart';
import 'package:tmbi/viewmodel/new_task/new_task_dashboard_viewmodel.dart';
import 'package:tmbi/widgets/error_container.dart';
import 'package:tmbi/widgets/new_task/app_drawer.dart';

import '../../config/converts.dart';
import '../../config/strings.dart';
import '../../models/new_task/task_response.dart';
import '../../network/api_service.dart';
import '../../network/ui_state.dart';
import '../../widgets/new_task/app_header.dart';
import '../../widgets/new_task/filter_section.dart';
import '../../widgets/new_task/status_cards.dart';
import '../../widgets/new_task/tab_selector.dart';
import '../../widgets/new_task/task_item.dart';
import '../login_screen.dart';
import '../todo/todo_home_screen.dart';
import 'notification_screen.dart';

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
      child: NewTaskDashboardScreen(staffId: staffId),
    );
  }

  // This function will be triggered on pull-to-refresh
  Future<void> _onRefresh(BuildContext context) async {
    final vm = Provider.of<NewTaskDashboardViewmodel>(context, listen: false);
    await vm
        .getTasks(); // Assuming you have a method in the ViewModel to refresh the data
  }

  Future<bool?> _showDeleteDialog(
      BuildContext context, Task task, NewTaskDashboardViewmodel ntdv) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task?"),
          content: Text("Are you sure you want to delete '${task.name}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
                ntdv.deleteTask(task.id);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NewTaskDashboardViewmodel>(context);

    if (vm.uiState == UiState.loading) {
      return Scaffold(
        body: Center(child: context.shimmerLoading()), // Show loading indicator
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (!staffId.isEmail()) {
            vm.reset();
          }
          Navigator.pushNamed(context, TodoHomeScreen.routeName,
              arguments: staffId);
        },
      ),
      drawer: AppDrawer(
        isEmailUser: staffId.isEmail(),
        staffId: staffId,
        staffName: "",
        onSync: () {
          Navigator.pushNamed(context, SyncScreen.routeName,
              arguments: staffId);
        },
        onLogout: () {
          _showLogoutDialog(context);
        },
        onAccountDeletion: () {
          showDeleteAccountDialog(context, vm);
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          // Trigger refresh on pull-to-refresh
          child: CustomScrollView(
            slivers: [
              // --- App Bar --- \\
              SliverToBoxAdapter(
                child: AppHeader(
                  onNotificationTap: () {
                    Navigator.pushNamed(context, NotificationScreen2.routeName,
                        arguments: staffId);
                  },
                ),
              ),
              // --- Tab Selector# Created By Me | Assigned To me -- \\
              SliverToBoxAdapter(
                child: SizedBox(height: Converts.c12),
              ),
              SliverToBoxAdapter(
                child: staffId.isEmail()
                    ? const SizedBox.shrink()
                    : TabSelector(
                        createdSelected: vm.selectedTab == 0,
                        onCreatedTap: () => vm.changeTab(0),
                        onAssignedTap: () => vm.changeTab(1),
                      ),
              ),
              // --- Filter Section --- \\
              SliverToBoxAdapter(
                child: staffId.isEmail()
                    ? const SizedBox.shrink()
                    : FilterSection(
                        selectedBU: vm.selectedBU,
                        buOptions: vm.compInfoList,
                        staffController: vm.staffController,
                        onBUChanged: (value) => vm.changeBU(value),
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
                  onFinalTap: (tsf) {
                    vm.changeStatus(tsf);
                  },
                ),
              ),
              // --- Tab Menu --- \\
              SliverToBoxAdapter(
                child: SizedBox(height: Converts.c12),
              ),
              SliverToBoxAdapter(
                child: _tabMenu(vm),
              ),
              // --- Task List --- \\
              vm.tasks.isNotEmpty
                  ? /*SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = vm.tasks[index];
                          return TaskItem(
                            task: task,
                            staffId: staffId,
                            completionText:
                                "${task.completion}% | ${task.status}",
                            completionColor: task.status ==
                                    TaskStatusFlag.completed.getData.first
                                ? Colors.green
                                : Colors.red,
                          );
                        },
                        childCount: vm.tasks.length,
                      ),
                    )*/
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = vm.tasks[index];

                          return Dismissible(
                            key: ValueKey(task.id),
                            direction: DismissDirection.startToEnd,
                            // right swipe
                            confirmDismiss: (direction) async {
                              // only open the dialog if status 'Created By Me'
                              if (vm.selectedTab == 0) {
                                _showDeleteDialog(context, task, vm);
                                return false; // don’t dismiss the item
                              } else {
                                return false; // do nothing
                              }
                            },
                            background: Container(
                              color: Colors.redAccent,
                              padding: const EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: const Icon(Icons.delete_forever,
                                  color: Colors.white),
                            ),
                            child: TaskItem(
                              task: task,
                              staffId: staffId,
                              completionText:
                                  "${task.completion}% | ${task.status}",
                              completionColor: task.status ==
                                      TaskStatusFlag.completed.getData.first
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
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
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabMenu(NewTaskDashboardViewmodel vm) {
    List<TaskStatusFlag> tabs = [
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

  void showDeleteAccountDialog(
      BuildContext context, NewTaskDashboardViewmodel vm) {
    final TextEditingController passwordController = TextEditingController();
    bool isButtonEnabled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.error_outline,
                          color: Colors.red, size: 40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Delete Your Account?",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "This action is final and cannot be undone. You will permanently lose all your data.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  _bulletPoint(
                      "You will permanently lose all your tasks and projects."),
                  _bulletPoint(
                      "Your profile and personal information will be erased."),
                  _bulletPoint("You will be removed from all shared projects."),
                  const SizedBox(height: 20),
                  const Text(
                    "To confirm, please enter your password.",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        isButtonEnabled = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () async {
                              await vm.deleteAccount(
                                  staffId, passwordController.text);
                              if (vm.isDeleted == true) {
                                if (context.mounted) {
                                  //Navigator.pop(context);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (Route<dynamic> route) =>
                                        false, // Removes all previous routes
                                  );
                                }
                              }
                              debugPrint("Result: ${vm.isDeleted}");
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Permanently Delete Account",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.black87)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.remove, size: 16, color: Colors.red),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
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
