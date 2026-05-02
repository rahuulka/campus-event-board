import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/event_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser!;
    final fs = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(radius: 40, child: Text(user.displayName?[0].toUpperCase() ?? 'U', style: const TextStyle(fontSize: 32))),
            ),
            const SizedBox(height: 12),
            Center(child: Text(user.displayName ?? 'User', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Center(child: Text(user.email ?? '')),
            const Divider(height: 32),
            const Text('My Posted Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: fs.getUserEvents(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Text('No events posted yet.');
                return Column(children: snapshot.data!.map((e) => EventCard(event: e)).toList());
              },
            ),
          ],
        ),
      ),
    );
  }
}