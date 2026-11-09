import 'package:flutter/material.dart';

import 'app_drawer.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/sessions_screen.dart';

/// Holds the bottom navigation (Groups, Sessions, Profile) and the side drawer.
/// IMPORTANT: the three tab screens must NOT have their own Scaffold.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final _tabs = const [HomeScreen(), SessionsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        selectedIndex: _index,
        onSelect: (i) => setState(() => _index = i),
      ),
      body: SafeArea(
        child: IndexedStack(index: _index, children: _tabs),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            label: 'Groups',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            label: 'Sessions',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
