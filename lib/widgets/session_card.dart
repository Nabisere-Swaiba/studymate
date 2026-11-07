import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionCard extends StatelessWidget {
  final Map<String, dynamic> session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final date = session['date'] as DateTime?;
    final start = session['startDateTime'] as DateTime?;
    final end = session['endDateTime'] as DateTime?;
    final title = (session['title'] as String?)?.trim();
    final groupName = (session['groupName'] as String?)?.trim();
    final location = (session['location'] as String?)?.trim();
    final time = start == null
        ? 'Time to be confirmed'
        : '${DateFormat.jm().format(start)}${end == null ? '' : ' - ${DateFormat.jm().format(end)}'}';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title == null || title.isEmpty ? 'Your session title' : title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.groups_outlined,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    groupName == null || groupName.isEmpty
                        ? 'Study group'
                        : groupName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: date == null
                  ? 'Date to be confirmed'
                  : DateFormat('EEE, MMM d, y').format(date),
            ),
            const SizedBox(height: 8),
            _DetailRow(icon: Icons.schedule_outlined, label: time),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.place_outlined,
              label: location == null || location.isEmpty
                  ? 'Location not set'
                  : location,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
