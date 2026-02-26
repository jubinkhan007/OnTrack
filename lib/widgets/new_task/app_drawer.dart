import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/config/app_theme.dart';

import '../../config/converts.dart';

class AppDrawer extends StatelessWidget {
  final String staffId;
  final String staffName;
  final bool isEmailUser;
  final VoidCallback onSync;
  final VoidCallback onLogout;
  final VoidCallback onAccountDeletion;
  final VoidCallback? onDashboards;
  //final VoidCallback onCardScan;

  const AppDrawer(
      {super.key,
      required this.staffId,
      required this.staffName,
      required this.onSync,
      required this.onLogout,
      required this.onAccountDeletion,
      required this.isEmailUser,
      this.onDashboards,
      //required this.onCardScan
      });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: Container(
        color: AppColors.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              decoration: const BoxDecoration(gradient: AppGradients.header),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/$staffId/$staffId-0.jpg",
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Center(
                            child: Icon(Icons.person_outline,
                                color: Colors.white),
                          ),
                          errorWidget: (_, __, ___) => const Center(
                            child: Icon(Icons.person_outline,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            staffName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            staffId,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.78),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  if (!isEmailUser)
                    _drawerItem(
                      icon: Icons.sync_rounded,
                      text: 'Sync',
                      onTap: onSync,
                    ),
                  if (Platform.isIOS)
                    _drawerItem(
                      icon: Icons.delete_forever_rounded,
                      text: 'Account delete',
                      danger: true,
                      onTap: onAccountDeletion,
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(height: 1),
                  ),
                  _drawerItem(
                    icon: Icons.bar_chart_rounded,
                    text: 'Dashboards',
                    onTap: () => onDashboards?.call(),
                  ),
                  _drawerItem(
                    icon: Icons.logout_rounded,
                    text: 'Logout',
                    danger: true,
                    onTap: onLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool selected = false,
    bool danger = false,
  }) {
    final fg = danger ? AppColors.danger : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(
          icon,
          color: selected ? AppColors.accent : fg.withOpacity(0.85),
          size: Converts.c16 + 2,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: selected ? AppColors.accent : fg.withOpacity(0.92),
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            fontSize: Converts.c16 - 2,
          ),
        ),
        onTap: onTap,
        selected: selected,
        selectedTileColor: AppColors.accent.withOpacity(0.10),
      ),
    );
  }
}
