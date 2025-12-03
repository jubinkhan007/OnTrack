import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/models/user_response.dart';

import '../../config/converts.dart';

class AppDrawer extends StatelessWidget {
  final String staffId;
  final String staffName;
  final VoidCallback onSync;
  final VoidCallback onLogout;
  final VoidCallback onAccountDeletion;

  const AppDrawer(
      {super.key,
      required this.staffId,
      required this.staffName,
      required this.onSync,
      required this.onLogout,
      required this.onAccountDeletion});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            accountName: Text(
              "Md. Salauddin",
              style: TextStyle(color: Colors.black, fontSize: Converts.c16 - 2),
            ),
            accountEmail: Text(
              "@$staffId",
              style: TextStyle(color: Colors.grey, fontSize: Converts.c16 - 4),
            ),
            currentAccountPicture: CircleAvatar(
              radius: Converts.c8,
              backgroundColor: Colors.blue.shade50,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/$staffId/$staffId-0.jpg",
                  fit: BoxFit.cover,
                  width: Converts.c64,
                  height: Converts.c64,
                  placeholder: (_, __) => const Icon(Icons.person_outline, color: Colors.blue),
                  errorWidget: (_, __, ___) => const Icon(Icons.person_outline, color: Colors.blue),
                ),
              ),
            ),
          ),

          // menu items
          _drawerItem(
            icon: Icons.sync,
            text: 'Sync',
            onTap: () {
              onSync();
            },
            selected: false,
          ),
          _drawerItem(
            icon: Icons.delete_forever,
            text: 'Account delete',
            onTap: () {
              onAccountDeletion();
            },
          ),
          _drawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              onLogout();
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.blue : Colors.black87, size: Converts.c16),
      title: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.blue : Colors.black87,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: Converts.c16 - 2
        ),
      ),
      onTap: onTap,
      selected: selected,
      selectedTileColor: Colors.blue.withOpacity(0.1),
    );
  }
}
