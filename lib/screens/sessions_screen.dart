import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/session_card.dart';
import 'add_session_screen.dart';

class SessionsScreen extends StatefulWidget {
  final VoidCallback? onMenuPressed;

  const SessionsScreen({super.key, this.onMenuPressed});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  static const _forest = Color(0xFF28613E);
  static const _leaf = Color(0xFF4D8A5E);
  static const _paleGreen = Color(0xFFEAF4E9);
  static const _borderGreen = Color(0xFFD8E8D8);
  static const _ink = Color(0xFF24332A);
  static const _muted = Color(0xFF718077);

  late final List<Map<String, dynamic>> _sessions = _sampleSessions();

  List<Map<String, dynamic>> _sampleSessions() {
    final today = DateUtils.dateOnly(DateTime.now());

    Map<String, dynamic> session({
      required int daysFromNow,
      required String title,
      required String group,
      required int startHour,
      required int startMinute,
      required int endHour,
      required int endMinute,
      required String location,
    }) {
      final date = today.add(Duration(days: daysFromNow));
      return {
        'id': 'demo-$daysFromNow',
        'title': title,
        'groupName': group,
        'date': date,
        'startDateTime': DateTime(
          date.year,
          date.month,
          date.day,
          startHour,
          startMinute,
        ),
        'endDateTime': DateTime(
          date.year,
          date.month,
          date.day,
          endHour,
          endMinute,
        ),
        'location': location,
      };
    }

    return [
      session(
        daysFromNow: 2,
        title: 'MAD review',
        group: 'The Controllers',
        startHour: 16,
        startMinute: 0,
        endHour: 17,
        endMinute: 30,
        location: 'ADB lab 4',
      ),
      session(
        daysFromNow: 4,
        title: 'AIS discussion',
        group: 'first class crew',
        startHour: 10,
        startMinute: 30,
        endHour: 12,
        endMinute: 0,
        location: 'main library',
      ),
      session(
        daysFromNow: 8,
        title: 'AWAD prep',
        group: 'Developer circle',
        startHour: 14,
        startMinute: 0,
        endHour: 15,
        endMinute: 30,
        location: 'ADB lab 1',
      ),
    ];
  }

  void _openMenu() {
    if (widget.onMenuPressed case final onMenuPressed?) {
      onMenuPressed();
      return;
    }
    Scaffold.maybeOf(context)?.openDrawer();
  }

  Future<void> _addSession() async {
    final session = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute<Map<String, dynamic>>(
        builder: (_) => const AddSessionScreen(),
      ),
    );

    if (session != null && mounted) {
      setState(() => _sessions.add(session));
    }
  }

  Map<String, List<Map<String, dynamic>>> _sessionsByMonth(
    List<Map<String, dynamic>> sessions,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final session in sessions) {
      final month = DateFormat('MMMM yyyy').format(session['date'] as DateTime);
      grouped.putIfAbsent(month, () => []).add(session);
    }
    return grouped;
  }

  Widget _buildMonthSection(
    BuildContext context,
    String month,
    List<Map<String, dynamic>> sessions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  month,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: _ink, fontWeight: FontWeight.w700),
                ),
              ),
              const Text(
                'All times local',
                style: TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ...sessions.map(
          (session) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SessionCard(session: session),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessions = [..._sessions]
      ..sort(
        (first, second) => (first['startDateTime'] as DateTime).compareTo(
          second['startDateTime'] as DateTime,
        ),
      );
    final studyGroups = sessions
        .map((session) => session['groupName'] as String)
        .toSet()
        .length;
    final sessionsByMonth = _sessionsByMonth(sessions);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 34),
          children: [
            Row(
              children: [
                Material(
                  color: _paleGreen,
                  borderRadius: BorderRadius.circular(14),
                  child: IconButton(
                    tooltip: 'Open navigation menu',
                    onPressed: _openMenu,
                    icon: const Icon(Icons.menu_rounded, color: _forest),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.auto_stories_rounded,
                  color: _forest,
                  size: 25,
                ),
                const SizedBox(width: 8),
                const Text(
                  'StudyMate',
                  style: TextStyle(
                    color: _forest,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 34),
            Text(
              'Make time to learn.',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _ink,
                fontWeight: FontWeight.w800,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              'Upcoming sessions from your joined groups, all in one place.',
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: _muted, height: 1.45),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: _paleGreen,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _borderGreen),
              ),
              child: Wrap(
                spacing: 34,
                runSpacing: 14,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _SummaryMetric(
                    value: '${sessions.length}',
                    label: 'upcoming sessions',
                    icon: Icons.event_note_rounded,
                  ),
                  Container(width: 1, height: 42, color: _borderGreen),
                  _SummaryMetric(
                    value: '$studyGroups',
                    label: 'study groups',
                    icon: Icons.groups_2_outlined,
                  ),
                  const Text(
                    'Sample sessions shown',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (sessions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 54),
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: _paleGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu_book_outlined,
                        color: _leaf,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nothing planned just yet',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: _ink, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Add a session and make your next study hour count.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _muted),
                    ),
                  ],
                ),
              )
            else
              ...sessionsByMonth.entries.map(
                (entry) => _buildMonthSection(context, entry.key, entry.value),
              ),
            const SizedBox(height: 18),
            Center(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _addSession,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add session'),
              ),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'A little planning goes a long way.',
                style: TextStyle(
                  color: _muted,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _SummaryMetric({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _SessionsScreenState._leaf, size: 22),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: _SessionsScreenState._forest,
                fontSize: 21,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: _SessionsScreenState._muted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
