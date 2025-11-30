import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/new_task/sync_repo.dart';

import '../../network/api_service.dart';
import '../../viewmodel/new_task/sync_viewmodel.dart';
import 'new_task_dashboard_screen.dart';

class SyncScreen extends StatelessWidget {
  final String staffId;

  const SyncScreen({super.key, required this.staffId});

  static const String routeName = '/sync_screen';

  static Widget create(String staffId) {
    return ChangeNotifierProvider(
      create: (_) => SyncViewmodel(
        syncRepo: SyncRepo(
            dio:
                ApiService("https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
      ),
      child: SyncScreen(
        staffId: staffId,
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
    if (vm.uiState == UiState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        /*Navigator.pushNamed(context, NewTaskDashboardScreen.routeName,
            arguments: staffId);*/
        Navigator.of(context).pushNamedAndRemoveUntil(
          NewTaskDashboardScreen.routeName, // Your home route
              (Route<dynamic> route) => false, // Remove all previous routes
          arguments: staffId, // Pass the staffId
        );
      });
    }

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
                ? const Text("Sync Complete!")
                : vm.uiState == UiState.error
                    ? Text("Error: ${vm.message}")
                    : const SizedBox(),
      ),
    );
  }
}
