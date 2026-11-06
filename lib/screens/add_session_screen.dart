// OWNER: Member 4
// PLACEHOLDER: replace with the Add session screen from Figma.
// Keep the class name AddSessionScreen and an empty constructor.
// This is a pushed screen, so it keeps its own Scaffold.
import 'package:flutter/material.dart';

class AddSessionScreen extends StatelessWidget {
  const AddSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add session')),
      body: const Center(child: Text('Add session - placeholder (Member 4)')),
    );
  }
}
