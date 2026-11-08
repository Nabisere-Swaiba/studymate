// OWNER: Member 5  (pushed screen - has its own Scaffold and Back button)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/study_group.dart';
import '../models/study_session.dart';
import '../services/auth_service.dart';
import '../services/group_service.dart';
import '../services/session_service.dart';
import '../theme.dart';
import '../widgets/app_dropdown.dart';
import '../widgets/app_header.dart';
import '../widgets/app_text_field.dart';
import '../widgets/info_banner.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({super.key});

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _venue = TextEditingController();
  final _auth = AuthService();
  final _sessions = SessionService();
  late final Stream<List<StudyGroup>> _myGroups = GroupService().myGroups(
    _auth.uid,
  );

  String? _groupId;
  DateTime? _date;
  TimeOfDay? _start;
  TimeOfDay? _end;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _dateCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _venue.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1),
    );
    if (d != null) {
      setState(() {
        _date = d;
        _dateCtrl.text = DateFormat('EEE, d MMMM y').format(d);
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final t = await showTimePicker(
      context: context,
      initialTime: (isStart ? _start : _end) ?? TimeOfDay.now(),
    );
    if (t != null && mounted) {
      setState(() {
        if (isStart) {
          _start = t;
          _startCtrl.text = t.format(context);
        } else {
          _end = t;
          _endCtrl.text = t.format(context);
        }
      });
    }
  }

  Future<void> _save(StudyGroup group) async {
    if (!_formKey.currentState!.validate()) return;
    final start = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _start!.hour,
      _start!.minute,
    );
    final end = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _end!.hour,
      _end!.minute,
    );
    if (!end.isAfter(start)) {
      setState(() => _error = 'End time must be after start time.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    try {
      await _sessions.addSession(
        StudySession(
          id: '',
          groupId: group.id,
          groupName: group.name,
          venue: _venue.text.trim(),
          isOnline: group.isOnline,
          start: start,
          end: end,
        ),
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Session scheduled')),
      );
      nav.pop();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Could not save the session. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  Widget _preview(StudyGroup? group) {
    if (_date == null || _start == null || _end == null) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR NEXT Swaiba DATE',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 0.5,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, d MMMM').format(_date!),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            '${_start!.format(context)} - ${_end!.format(context)}'
            '${group != null ? ' · ${group.name}' : ''}',
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<StudyGroup>>(
          stream: _myGroups,
          builder: (context, snap) {
            final groups = snap.data ?? [];
            StudyGroup? selected;
            for (final g in groups) {
              if (g.id == _groupId) selected = g;
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('Back'),
                      ),
                    ),
                    const AppHeader(showMenu: false),
                    const SizedBox(height: 12),
                    const Text(
                      'Put it in the calendar.',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Set a time and place for your next shared lightbulb moment.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 18),
                    AppDropdown(
                      label: 'Study group',
                      hint: 'Choose from your joined groups',
                      items: {for (final g in groups) g.id: g.name},
                      value: selected?.id,
                      onChanged: (v) => setState(() => _groupId = v),
                      validator: (v) => v == null ? 'Choose a group' : null,
                    ),
                    AppTextField(
                      label: 'Date',
                      controller: _dateCtrl,
                      readOnly: true,
                      icon: Icons.calendar_today_outlined,
                      onTap: _pickDate,
                      validator: _required,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Start time',
                            controller: _startCtrl,
                            readOnly: true,
                            icon: Icons.access_time,
                            onTap: () => _pickTime(true),
                            validator: _required,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppTextField(
                            label: 'End time',
                            controller: _endCtrl,
                            readOnly: true,
                            icon: Icons.access_time,
                            onTap: () => _pickTime(false),
                            validator: _required,
                          ),
                        ),
                      ],
                    ),
                    AppTextField(
                      label: 'Venue or meeting link',
                      controller: _venue,
                      hint: 'e.g. Library, Room 2.04',
                      icon: Icons.place_outlined,
                      validator: _required,
                    ),
                    _preview(selected),
                    if (selected != null)
                      InfoBanner(
                        message:
                            'This session will appear in Study Sessions for all ${selected.members.length} members of ${selected.name}.',
                      ),
                    if (_error != null)
                      InfoBanner(message: _error!, isError: true),
                    ElevatedButton(
                      onPressed: (_saving || selected == null)
                          ? null
                          : () => _save(selected!),
                      child: _saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Schedule session'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
