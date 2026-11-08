import 'package:flutter/material.dart';

import '../theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 34});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );
  }
}

/// Logo + app name + optional hamburger that opens the drawer.
/// Set showMenu: false on screens that are pushed (they have no drawer).
class AppHeader extends StatelessWidget {
  final bool showMenu;
  const AppHeader({super.key, this.showMenu = true});

  @override
  Widget build(BuildContext context) {
    return Row(
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
        if (showMenu)
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
            ),
            icon: const Icon(Icons.menu, color: AppColors.primary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
      ],
    );
  }
}
