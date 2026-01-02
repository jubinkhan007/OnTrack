import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/new_task/sync_repo.dart';

import '../../config/converts.dart';
import '../../network/api_service.dart';
import '../../viewmodel/new_task/sync_viewmodel.dart';
import 'new_task_dashboard_screen.dart';

class SyncScreen extends StatelessWidget {
  final String staffId, staffName;

  const SyncScreen({super.key, required this.staffId, required this.staffName});

  static const String routeName = '/sync_screen';

  static Widget create(String staffId, String staffName) {
    return ChangeNotifierProvider(
      create: (_) => SyncViewmodel(
        staffId: staffId,
        syncRepo: SyncRepo(
            dio:
                ApiService("https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
      ),
      child: SyncScreen(
        staffId: staffId, staffName: staffName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SyncViewmodel>();
    if (vm.uiState == UiState.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Navigate to Home when sync is complete
    /*if (vm.uiState == UiState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            NewTaskDashboardScreen.routeName, // Your home route
            (Route<dynamic> route) => false, // Remove all previous routes
            arguments: staffId, // Pass the staffId
          );
        }
      });
    }*/

    return Scaffold(
      //appBar: AppBar(title: const Text("Sync BU Units")),
      body: Center(
        child: vm.uiState == UiState.loading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: vm.progressPercent / 100,
                  ),
                  const SizedBox(height: 20),
                  Text("${vm.progressPercent.toStringAsFixed(1)}%"),
                  Text(
                      "${(vm.progressPercent / 100 * vm.buResponse!.bu.length).toInt()} / ${vm.buResponse!.bu.length} saved"),
                ],
              )
            : vm.uiState == UiState.success
                ? //const Text("Sync Complete!")
                AllSetWidget(
                    onStart: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        NewTaskDashboardScreen.routeName,
                        (Route<dynamic> route) =>
                            false,
                        arguments: {
                          'staffId': staffId,
                          'name': staffName, // if needed
                        },
                      );
                    },
                  )
                : vm.uiState == UiState.error
                    ? Center(child: Text("Error: ${vm.message}"))
                    : const SizedBox(),
      ),
    );
  }
}

class AllSetWidget extends StatelessWidget {
  final VoidCallback onStart;

  const AllSetWidget({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Green check icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.1),
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: Converts.c56,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "You're All Set!",
              style: TextStyle(
                fontSize: Converts.c24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Welcome! You're ready to go. "
              "Here are a few tips to get started:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Converts.c16 - 2,
                color: Colors.black54,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            _tipsBox(),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: Converts.c48,
              child: ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Start Using App",
                  style: TextStyle(fontSize: Converts.c16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tips box widget
  Widget _tipsBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _tipRow(Icons.add_circle,
              "Tap the '+' button to create your first task."),
          const SizedBox(height: 14),
          _tipRow(Icons.swipe, "Swipe right on a task to delete it (if you created it)."),
          const SizedBox(height: 14),
          _tipRow(Icons.notifications_active,
              "You will notify me when a new task is received."),
          const SizedBox(height: 14),
          _tipRow(Icons.person, "Type '@' plus letters to get a name to assign someone in the task."),
        ],
      ),
    );
  }

  // Reusable row
  Widget _tipRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
