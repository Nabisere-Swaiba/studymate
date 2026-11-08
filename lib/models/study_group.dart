import 'package:cloud_firestore/cloud_firestore.dart';

class StudyGroup {
  final String id, name, courseUnit, description, meetingMode, creatorId;
  final String course, year;
  final int maxMembers;
  final List<String> members;

  StudyGroup({
    required this.id,
    required this.name,
    required this.courseUnit,
    required this.description,
    required this.meetingMode,
    required this.creatorId,
    required this.course,
    required this.year,
    required this.maxMembers,
    required this.members,
  });

  factory StudyGroup.fromDoc(DocumentSnapshot d) {
    final m = (d.data() as Map<String, dynamic>?) ?? {};
    return StudyGroup(
      id: d.id,
      name: m['name'] ?? '',
      courseUnit: m['courseUnit'] ?? '',
      description: m['description'] ?? '',
      meetingMode: m['meetingMode'] ?? 'In person',
      creatorId: m['creatorId'] ?? '',
      course: m['course'] ?? '',
      year: m['year'] ?? '',
      maxMembers: (m['maxMembers'] ?? 10) as int,
      members: List<String>.from(m['members'] ?? []),
    );
  }

  bool get isOnline => meetingMode == 'Online';
  bool get isFull => members.length >= maxMembers;
  bool hasMember(String uid) => members.contains(uid);
}
