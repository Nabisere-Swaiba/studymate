import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid, name, email, course, year;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.course,
    required this.year,
  });

  factory AppUser.fromDoc(DocumentSnapshot d) {
    final m = (d.data() as Map<String, dynamic>?) ?? {};
    return AppUser(
      uid: d.id,
      name: m['name'] ?? '',
      email: m['email'] ?? '',
      course: m['course'] ?? '',
      year: m['year'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'course': course,
        'year': year,
      };

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
