import 'package:flutter/material.dart';

import 'models/app_user.dart';
import 'screens/create_group_screen.dart';
import 'services/auth_service.dart';
import 'theme.dart';
import 'widgets/app_header.dart';

class AppDrawer extends StatelessWidget {
  final ValueChanged<int> onSelect;
  final int selectedIndex;
  const AppDrawer({super.key, required this.onSelect, this.selectedIndex = 0});

  Widget _navItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? AppColors.primary : AppColors.textDark,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(Icons.circle, size: 8, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _soon(BuildContext context, String what) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text('$what is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Header: logo, name, close button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  const AppLogo(),
                  const SizedBox(width: 8),
                  const Text(
                    'studyMate',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // User card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: StreamBuilder<AppUser?>(
                stream: auth.userStream(auth.uid),
                builder: (context, snap) {
                  final u = snap.data;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            u?.initials ?? '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                u?.name ?? 'Student',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                u?.email ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              Text(
                                '${u?.course ?? ''} ${u?.year ?? ''}'.trim(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Navigation
            _navItem(
              icon: Icons.groups_outlined,
              label: 'Groups',
              selected: selectedIndex == 0,
              onTap: () {
                Navigator.pop(context);
                onSelect(0);
              },
            ),
            _navItem(
              icon: Icons.event_outlined,
              label: 'Sessions',
              selected: selectedIndex == 1,
              onTap: () {
                Navigator.pop(context);
                onSelect(1);
              },
            ),
            _navItem(
              icon: Icons.person_outline,
              label: 'Profile',
              selected: selectedIndex == 2,
              onTap: () {
                Navigator.pop(context);
                onSelect(2);
              },
            ),
            _navItem(
              icon: Icons.add,
              label: 'Create Group',
              onTap: () {
                final nav = Navigator.of(context);
                nav.pop();
                nav.push(
                  MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(),
            ),
            _navItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => _soon(context, 'Settings'),
            ),
            _navItem(
              icon: Icons.help_outline,
              label: 'Help',
              onTap: () => _soon(context, 'Help'),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(),
            ),
            _navItem(
              icon: Icons.logout,
              label: 'Log out',
              onTap: () async {
                Navigator.pop(context);
                await auth.signOut();
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 14),
              child: Text(
                'Small groups. Big lightbulb moments.',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
