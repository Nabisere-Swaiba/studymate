import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/study_session.dart';

class SessionService {
  final _db = FirebaseFirestore.instance;

  /// Upcoming sessions for the given groups, soonest first.
  /// We filter and sort in Dart so no Firestore index is needed.
  Stream<List<StudySession>> upcomingForGroups(List<String> groupIds) {
    if (groupIds.isEmpty) return Stream.value(<StudySession>[]);
    // whereIn accepts a limited number of ids; 10 is always safe.
    final ids = groupIds.take(10).toList();
    return _db
        .collection('sessions')
        .where('groupId', whereIn: ids)
        .snapshots()
        .map((snap) {
      final now = DateTime.now();
      final list = snap.docs
          .map((d) => StudySession.fromDoc(d))
          .where((s) => s.end.isAfter(now))
          .toList();
      list.sort((a, b) => a.start.compareTo(b.start));
      return list;
    });
  }

  Future<void> addSession(StudySession s) {
    return _db.collection('sessions').add(s.toMap());
  }
}
