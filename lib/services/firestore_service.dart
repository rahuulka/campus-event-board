import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<EventModel>> getEvents() {
    return _db
        .collection('events')
        .orderBy('date')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => EventModel.fromFirestore(doc)).toList());
  }

  Future<void> createEvent(EventModel event) async {
    await _db.collection('events').add(event.toMap());
  }

  Future<void> rsvpEvent(String eventId, String userId) async {
    await _db.collection('events').doc(eventId).collection('attendees').doc(userId).set({
      'rsvpedAt': FieldValue.serverTimestamp(),
      'status': 'going',
    });
  }

  Future<void> cancelRsvp(String eventId, String userId) async {
    await _db.collection('events').doc(eventId).collection('attendees').doc(userId).delete();
  }

  Stream<bool> isRsvped(String eventId, String userId) {
    return _db.collection('events').doc(eventId).collection('attendees').doc(userId)
        .snapshots().map((doc) => doc.exists);
  }

  Stream<int> getAttendeeCount(String eventId) {
    return _db.collection('events').doc(eventId).collection('attendees')
        .snapshots().map((snap) => snap.size);
  }

  Stream<List<EventModel>> getUserEvents(String userId) {
    return _db.collection('events')
        .where('organizerId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => EventModel.fromFirestore(doc)).toList());
  }
}