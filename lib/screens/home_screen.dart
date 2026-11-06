// OWNER: Member 2
// PLACEHOLDER: replace with the Browse groups screen from Figma.
// Keep the class name HomeScreen. This tab must NOT have its own Scaffold.
// Also add lib/widgets/group_card.dart for the group cards.
import 'package:flutter/material.dart';

import '../widgets/app_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        AppHeader(),
        SizedBox(height: 20),
        Text('Browse groups - placeholder (Member 2)'),
      ],
    );
  }
}
