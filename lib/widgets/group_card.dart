import 'package:flutter/material.dart';

import '../models/study_group.dart';
import '../theme.dart';
import 'tag_chip.dart';

class GroupCard extends StatelessWidget {
  final StudyGroup group;
  final String uid;
  final VoidCallback onJoin;

  const GroupCard({
    super.key,
    required this.group,
    required this.uid,
    required this.onJoin,
  });

  Widget _button() {
    final style = ElevatedButton.styleFrom(
      minimumSize: const Size(84, 36),
      padding: const EdgeInsets.symmetric(horizontal: 14),
    );
    if (group.hasMember(uid)) {
      return ElevatedButton.icon(
        style: style,
        onPressed: null,
        icon: const Icon(Icons.check, size: 16),
        label: const Text('Joined'),
      );
    }
    if (group.isFull) {
      return ElevatedButton(style: style, onPressed: null, child: const Text('Full'));
    }
    return ElevatedButton(style: style, onPressed: onJoin, child: const Text('Join'));
  }

  @override
  Widget build(BuildContext context) {
    final code = group.courseUnit.split(' ').first.toUpperCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(code,
                  style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.5,
                      color: AppColors.textMuted)),
              const Spacer(),
              TagChip(group.isOnline ? 'Online' : 'Campus',
                  icon: group.isOnline
                      ? Icons.videocam_outlined
                      : Icons.location_on_outlined),
            ],
          ),
          const SizedBox(height: 6),
          Text(group.name,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(group.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.people_outline,
                  size: 16, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text('${group.members.length}/${group.maxMembers} members',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
              const Spacer(),
              _button(),
            ],
          ),
        ],
      ),
    );
  }
}
