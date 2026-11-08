import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/study_group.dart';

class GroupService {
  final _db = FirebaseFirestore.instance;

  Stream<List<StudyGroup>> allGroups() {
    return _db
        .collection('groups')
        .snapshots()
        .map((s) => s.docs.map((d) => StudyGroup.fromDoc(d)).toList());
  }

  /// Groups that the given user has joined.
  Stream<List<StudyGroup>> myGroups(String uid) {
    return _db
        .collection('groups')
        .where('members', arrayContains: uid)
        .snapshots()
        .map((s) => s.docs.map((d) => StudyGroup.fromDoc(d)).toList());
  }

  Future<void> join(String groupId, String uid) {
    return _db.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> createGroup({
    required String name,
    required String courseUnit,
    required String description,
    required int maxMembers,
    required String meetingMode,
    required AppUser creator,
  }) {
    return _db.collection('groups').add({
      'name': name.trim(),
      'courseUnit': courseUnit,
      'description': description.trim(),
      'maxMembers': maxMembers,
      'meetingMode': meetingMode,
      'creatorId': creator.uid,
      'course': creator.course,
      'year': creator.year,
      'members': [creator.uid],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
