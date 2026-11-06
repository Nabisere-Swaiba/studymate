// OWNER: Member 3
// PLACEHOLDER: replace with the Create group screen from Figma.
// Keep the class name CreateGroupScreen and an empty constructor.
// This is a pushed screen, so it keeps its own Scaffold.
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create group')),
      body: const Center(child: Text('Create group - placeholder (Member 3)')),
    );
  }
}
