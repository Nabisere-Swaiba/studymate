import 'package:cloud_firestore/cloud_firestore.dart';

class StudySession {
  final String id, groupId, groupName, venue;
  final bool isOnline;
  final DateTime start, end;

  StudySession({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.venue,
    required this.isOnline,
    required this.start,
    required this.end,
  });

  factory StudySession.fromDoc(DocumentSnapshot d) {
    final m = (d.data() as Map<String, dynamic>?) ?? {};
    return StudySession(
      id: d.id,
      groupId: m['groupId'] ?? '',
      groupName: m['groupName'] ?? '',
      venue: m['venue'] ?? '',
      isOnline: m['isOnline'] ?? false,
      start: (m['start'] as Timestamp).toDate(),
      end: (m['end'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'groupId': groupId,
        'groupName': groupName,
        'venue': venue,
        'isOnline': isOnline,
        'start': Timestamp.fromDate(start),
        'end': Timestamp.fromDate(end),
      };
}
