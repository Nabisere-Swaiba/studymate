
import 'package:flutter/material.dart';

import 'services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  final ValueChanged<int> onSelect;
  const AppDrawer({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Groups'),
              onTap: () {
                Navigator.pop(context);
                onSelect(0);
              },
            ),
            ListTile(
              title: const Text('Sessions'),
              onTap: () {
                Navigator.pop(context);
                onSelect(1);
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                onSelect(2);
              },
            ),
            ListTile(
              title: const Text('Log out'),
              onTap: () {
                Navigator.pop(context);
                AuthService().signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
