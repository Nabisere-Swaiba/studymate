// OWNER: Member 4  (pushed screen - has its own Scaffold and Back button)
import 'package:flutter/material.dart';

import '../data/courses.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/group_service.dart';
import '../theme.dart';
import '../widgets/app_dropdown.dart';
import '../widgets/app_header.dart';
import '../widgets/app_text_field.dart';
import '../widgets/info_banner.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _max = TextEditingController(text: '6');
  final _auth = AuthService();
  final _groups = GroupService();

  String? _unit;
  String _mode = 'In person';
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _max.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    try {
      final uid = _auth.uid;
      final creator =
          await _auth.getUser(uid) ??
          AppUser(uid: uid, name: '', email: '', course: '', year: '');
      await _groups.createGroup(
        name: _name.text,
        courseUnit: _unit!,
        description: _description.text,
        maxMembers: int.parse(_max.text.trim()),
        meetingMode: _mode,
        creator: creator,
      );
      messenger.showSnackBar(
        SnackBar(content: Text('${_name.text.trim()} created')),
      );
      nav.pop();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Could not create the group. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _modeButton(String label, IconData icon) {
    final selected = _mode == label;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _mode = label),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryLight : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                  'Start a study circle.',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const Text(
                  'Bring your classmates together around a shared goal.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Group name',
                  controller: _name,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Give your group a name'
                      : null,
                ),
                AppDropdown(
                  label: 'Course unit',
                  hint: 'Select a course unit',
                  items: asItems(kCourseUnits),
                  value: _unit,
                  onChanged: (v) => setState(() => _unit = v),
                  validator: (v) => v == null ? 'Select a course unit' : null,
                ),
                AppTextField(
                  label: 'Description',
                  controller: _description,
                  maxLines: 3,
                  hint: 'What will your group work on?',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Add a short description'
                      : null,
                ),
                AppTextField(
                  label: 'Maximum members',
                  controller: _max,
                  icon: Icons.people_outline,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n < 2 || n > 20) {
                      return 'Choose 2-20 members, including you.';
                    }
                    return null;
                  },
                ),
                const Text(
                  'How will you meet?',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _modeButton('In person', Icons.location_on_outlined),
                    const SizedBox(width: 10),
                    _modeButton('Online', Icons.videocam_outlined),
                  ],
                ),
                const SizedBox(height: 16),
                const InfoBanner(
                  message: "You'll be the first member. Your group will appear in Browse Groups for classmates to join.",
                ),
                if (_error != null) InfoBanner(message: _error!, isError: true),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Text('Create group'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
