import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/new_task/notification_repo.dart';
import 'package:tmbi/viewmodel/new_task/notification_viewmodel.dart';
import 'package:tmbi/widgets/error_container.dart';
import '../../config/converts.dart';
import '../../network/api_service.dart';
import '../../widgets/new_task/notification_item.dart';

class NotificationScreen2 extends StatelessWidget {
  final String staffId;
  static const String routeName = '/notification2_screen';

  const NotificationScreen2({super.key, required this.staffId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewmodel(
        notifRepo: NotificationRepo(
            dio:
                ApiService("https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
      )..getNotif(staffId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Palette.mainColor,
          title: Text(
            "Notifications",
            style: TextStyle(fontSize: Converts.c16),
          ),
          actions: [
            /*TextButton(
              onPressed: () {},
              child: const Text("Clear"),
            )*/
          ],
        ),
        body: Consumer<NotificationViewmodel>(
          builder: (context, provider, _) {
            if (provider.uiState == UiState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.notificationList.isEmpty) {
              return const Center(
                  child: ErrorContainer(message: "(no notification found)"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.notificationList.length,
              itemBuilder: (context, index) {
                return NotificationItem(
                  model: provider.notificationList[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
