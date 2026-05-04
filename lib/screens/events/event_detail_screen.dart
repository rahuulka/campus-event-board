import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/event_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final uid = auth.currentUser!.uid;
    final fs = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageUrl != null)
              Image.network(event.imageUrl!, height: 220, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(label: Text(event.category)),
                  const SizedBox(height: 8),
                  Text(event.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [const Icon(Icons.calendar_today, size: 16), const SizedBox(width: 6), Text(DateFormat('EEEE, MMMM d, yyyy').format(event.date))]),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.location_on, size: 16), const SizedBox(width: 6), Text(event.location)]),
                  const Divider(height: 32),
                  const Text('About this event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(event.description),
                  const Divider(height: 32),
                  StreamBuilder<int>(
                    stream: fs.getAttendeeCount(event.id),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return Text('$count people going', style: const TextStyle(fontWeight: FontWeight.bold));
                    },
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<bool>(
                    stream: fs.isRsvped(event.id, uid),
                    builder: (context, snapshot) {
                      final rsvped = snapshot.data ?? false;
                      return ElevatedButton.icon(
                        onPressed: () => rsvped ? fs.cancelRsvp(event.id, uid) : fs.rsvpEvent(event.id, uid),
                        icon: Icon(rsvped ? Icons.check_circle : Icons.add_circle_outline),
                        label: Text(rsvped ? 'Cancel RSVP' : 'RSVP to this event'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: rsvped ? Colors.grey : Colors.blue, foregroundColor: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}