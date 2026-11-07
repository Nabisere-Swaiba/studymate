// OWNER: Member 5  (Profile tab - no Scaffold, it lives inside AppShell)
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/app_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _row(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted)),
                Text(value.isEmpty ? '-' : value,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return StreamBuilder<AppUser?>(
      stream: auth.userStream(auth.uid),
      builder: (context, snap) {
        final u = snap.data;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            const AppHeader(),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryLight,
                child: Text(u?.initials ?? '?',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(u?.name ?? '',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 20),
            _row(Icons.mail_outline, 'Email', u?.email ?? ''),
            _row(Icons.school_outlined, 'Course', u?.course ?? ''),
            _row(Icons.calendar_today_outlined, 'Year of study', u?.year ?? ''),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => auth.signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }
}
