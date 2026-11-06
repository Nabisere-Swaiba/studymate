
import 'package:flutter/material.dart';

import '../data/courses.dart';
import '../models/study_group.dart';
import '../services/auth_service.dart';
import '../services/group_service.dart';
import '../theme.dart';
import '../widgets/app_header.dart';
import '../widgets/group_card.dart';
import 'create_group_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _groups = GroupService();
  final _auth = AuthService();
  final _search = TextEditingController();
  late final Stream<List<StudyGroup>> _stream = _groups.allGroups();

  String _query = '';
  String? _course;
  String? _year;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(StudyGroup g) {
    final q = _query.trim().toLowerCase();
    final textOk = q.isEmpty ||
        g.name.toLowerCase().contains(q) ||
        g.courseUnit.toLowerCase().contains(q) ||
        g.description.toLowerCase().contains(q);
    final courseOk = _course == null || g.course == _course;
    final yearOk = _year == null || g.year == _year;
    return textOk && courseOk && yearOk;
  }

  Future<void> _join(StudyGroup g) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _groups.join(g.id, _auth.uid);
      messenger.showSnackBar(SnackBar(content: Text('You joined ${g.name}')));
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Could not join. Please try again.')));
    }
  }

  Widget _filterMenu(String label, bool active, List<String> options,
      ValueChanged<String> onSelected) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (_) =>
          options.map((o) => PopupMenuItem(value: o, child: Text(o))).toList(),
      child: Chip(
        label: Text('$label ▾'),
        backgroundColor: active ? AppColors.primary : Colors.white,
        labelStyle: TextStyle(
            color: active ? Colors.white : AppColors.textDark, fontSize: 12),
        side: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.uid;
    return StreamBuilder<List<StudyGroup>>(
      stream: _stream,
      builder: (context, snap) {
        final filtered = (snap.data ?? []).where(_matches).toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            const AppHeader(),
            const SizedBox(height: 16),
            const Text('YOUR CAMPUS',
                style: TextStyle(
                    fontSize: 10, letterSpacing: 1, color: AppColors.textMuted)),
            const Text('Find your study circle.',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const Text('Same course. Shared goals. Better together.',
                style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 14),
            TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search groups, topics or units',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterMenu(_course ?? 'Course', _course != null, kCourses,
                      (v) => setState(() => _course = v)),
                  const SizedBox(width: 8),
                  _filterMenu(_year ?? 'Year', _year != null, kYears,
                      (v) => setState(() => _year = v)),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _course == null && _year == null,
                    onSelected: (_) => setState(() {
                      _course = null;
                      _year = null;
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                    '${filtered.length} study group${filtered.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CreateGroupScreen())),
                  child: const Text('+ Create group'),
                ),
              ],
            ),
            if (snap.hasError)
              Text('Error: ${snap.error}',
                  style: const TextStyle(color: AppColors.error))
            else if (snap.connectionState == ConnectionState.waiting &&
                !snap.hasData)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text('No groups yet. Create one!',
                      style: TextStyle(color: AppColors.textMuted)),
                ),
              )
            else
              ...filtered.map((g) =>
                  GroupCard(group: g, uid: uid, onJoin: () => _join(g))),
          ],
        );
      },
    );
  }
}
