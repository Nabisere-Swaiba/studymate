// OWNER: Member 5
// PLACEHOLDER: replace with the Profile screen (no Figma design, keep the green style).
// Keep the class name ProfileScreen. This tab must NOT have its own Scaffold.
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/app_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const AppHeader(),
        const SizedBox(height: 20),
        const Text('Profile - placeholder (Member 5)'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => AuthService().signOut(),
          child: const Text('Log out'),
        ),
      ],
    );
  }
}
