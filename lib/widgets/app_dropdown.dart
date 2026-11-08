// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

/// Turns a simple list into the {value: label} map AppDropdown expects.
Map<String, String> asItems(List<String> list) => {for (final e in list) e: e};

class AppDropdown extends StatelessWidget {
  final String label;
  final Map<String, String> items; // value -> label shown
  final String? value;
  final String? hint;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
          items: items.entries
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e.key,
                  child: Text(e.value, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
