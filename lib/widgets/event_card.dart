import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../screens/events/event_detail_screen.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageUrl != null)
              Image.network(event.imageUrl!, height: 160, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(label: Text(event.category, style: const TextStyle(fontSize: 12)), padding: EdgeInsets.zero),
                      const Spacer(),
                      Text(DateFormat('MMM d, yyyy').format(event.date), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(event.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.location_on, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(event.location, style: const TextStyle(color: Colors.grey))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}