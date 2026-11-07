import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/session_card.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({super.key});

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _groupController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _groupController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  DateTime? _dateTimeFor(TimeOfDay? time) {
    if (_date == null || time == null) return null;
    return DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      time.hour,
      time.minute,
    );
  }

  String _formatDate(DateTime? date) =>
      date == null ? 'Choose a date' : DateFormat('EEE, MMM d, y').format(date);

  String _formatTime(TimeOfDay? time) =>
      time == null ? 'Choose time' : time.format(context);

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 5),
    );
    if (selectedDate != null) {
      setState(() => _date = selectedDate);
      _formKey.currentState?.validate();
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime:
          (isStart ? _startTime : _endTime) ??
          const TimeOfDay(hour: 10, minute: 0),
    );
    if (selectedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = selectedTime;
        } else {
          _endTime = selectedTime;
        }
      });
      _formKey.currentState?.validate();
    }
  }

  String? _validateEndTime(TimeOfDay? value) {
    if (value == null) return 'Choose an end time';
    if (_startTime != null &&
        (value.hour * 60 + value.minute) <=
            (_startTime!.hour * 60 + _startTime!.minute)) {
      return 'End time must be later than start time';
    }
    return null;
  }

  void _saveSession() {
    if (!_formKey.currentState!.validate()) return;

    final startDateTime = _dateTimeFor(_startTime)!;
    final endDateTime = _dateTimeFor(_endTime)!;
    final session = <String, dynamic>{
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'groupId': null,
      'groupName': _groupController.text.trim(),
      'date': _date!,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'location': _locationController.text.trim(),
    };
    Navigator.of(context).pop<Map<String, dynamic>>(session);
  }

  Map<String, dynamic> get _previewSession => {
    'title': _titleController.text.trim(),
    'groupName': _groupController.text.trim(),
    'date': _date,
    'startDateTime': _dateTimeFor(_startTime),
    'endDateTime': _dateTimeFor(_endTime),
    'location': _locationController.text.trim(),
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fieldDecoration = const InputDecoration(
      border: OutlineInputBorder(),
      alignLabelWithHint: true,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Plan a study session')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  Text(
                    'Bring your group together',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add the details so everyone knows when and where to meet.',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Demo storage only. Sessions are not saved permanently or shared with group members yet.',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _titleController,
                    decoration: fieldDecoration.copyWith(
                      labelText: 'Session title *',
                      hintText: 'e.g. Biology exam review',
                      prefixIcon: const Icon(Icons.edit_calendar_outlined),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter a session title'
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: fieldDecoration.copyWith(
                      labelText: 'Description',
                      hintText: 'What will your group work on?',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 2,
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _groupController,
                    decoration: fieldDecoration.copyWith(
                      labelText: 'Study group *',
                      hintText: 'Enter the group name',
                      prefixIcon: const Icon(Icons.groups_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter a study group'
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    decoration: fieldDecoration.copyWith(
                      labelText: 'Date *',
                      hintText: 'Choose a date',
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    key: ValueKey<DateTime?>(_date),
                    initialValue: _formatDate(_date),
                    onTap: _pickDate,
                    validator: (_) =>
                        _date == null ? 'Choose a session date' : null,
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final startField = _timeField(
                        label: 'Start time *',
                        time: _startTime,
                        validator: (value) =>
                            value == null ? 'Choose a start time' : null,
                        onTap: () => _pickTime(isStart: true),
                      );
                      final endField = _timeField(
                        label: 'End time *',
                        time: _endTime,
                        validator: _validateEndTime,
                        onTap: () => _pickTime(isStart: false),
                      );
                      if (constraints.maxWidth < 520) {
                        return Column(
                          children: [
                            startField,
                            const SizedBox(height: 16),
                            endField,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: startField),
                          const SizedBox(width: 16),
                          Expanded(child: endField),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: fieldDecoration.copyWith(
                      labelText: 'Location or meeting link',
                      hintText: 'Library room or video call link',
                      prefixIcon: const Icon(Icons.place_outlined),
                    ),
                    keyboardType: TextInputType.url,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Preview',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  SessionCard(session: _previewSession),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      FilledButton.icon(
                        onPressed: _saveSession,
                        icon: const Icon(Icons.check),
                        label: const Text('Save session'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeField({
    required String label,
    required TimeOfDay? time,
    required String? Function(TimeOfDay?) validator,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.schedule_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      key: ValueKey<TimeOfDay?>(time),
      initialValue: _formatTime(time),
      validator: (_) => validator(time),
      onTap: onTap,
    );
  }
}
