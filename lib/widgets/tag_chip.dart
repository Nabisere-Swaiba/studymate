import 'package:flutter/material.dart';

import '../theme.dart';

class TagChip extends StatelessWidget {
  final String text;
  final IconData? icon;
  const TagChip(this.text, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, size: 13, color: AppColors.textMuted),
        if (icon != null) const SizedBox(width: 3),
        Text(text,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }
}
