import 'package:flutter/material.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/app_theme.dart';
import '../../config/converts.dart';

class AppHeader extends StatelessWidget {
  //final VoidCallback onLogoutTap;
  final VoidCallback onNotificationTap;

  //final VoidCallback onSyncTap;

  const AppHeader({
    super.key,
    //required this.onLogoutTap,
    required this.onNotificationTap,
    //required this.onSyncTap
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Converts.c8, vertical: 10),
      decoration: const BoxDecoration(
        gradient: AppGradients.header,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateTime.now().getGreeting(),
                        style: textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        )),
                    Text(DateTime.now().toFormattedString(),
                        style: TextStyle(
                          fontSize: Converts.c16 - 2,
                          color: Colors.white.withOpacity(0.85),
                        )),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              /*IconButton(
                onPressed: () {
                  onSyncTap();
                },
                icon: const Icon(Icons.sync),
              ),*/
              /*IconButton(
                onPressed: () {
                  onLogoutTap();
                },
                icon: const Icon(Icons.login_outlined),
              ),*/
              IconButton(
                onPressed: () {
                  onNotificationTap();
                },
                icon: const Icon(Icons.notifications, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
