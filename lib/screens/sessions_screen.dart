// OWNER: Member 4
// PLACEHOLDER: replace with the Study sessions screen from Figma.
// Keep the class name SessionsScreen. This tab must NOT have its own Scaffold.
// Also add lib/widgets/session_card.dart for the session cards.
import 'package:flutter/material.dart';

import '../widgets/app_header.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        AppHeader(),
        SizedBox(height: 20),
        Text('Study sessions - placeholder (Member 4)'),
      ],
    );
  }
}
