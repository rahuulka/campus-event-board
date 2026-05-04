import 'package:flutter/material.dart';
import '../../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final List<String> _categories = [
    'Academic',
    'Sports',
    'Social',
    'Arts',
    'Career'
  ];

  final Map<String, bool> _subscriptions = {
    'Academic': false,
    'Sports': false,
    'Social': false,
    'Arts': false,
    'Career': false,
  };

  final NotificationService _ns = NotificationService();
  bool _loading = false;

  void _toggle(String category, bool value) async {
    setState(() => _loading = true);
    setState(() => _subscriptions[category] = value);
    if (value) {
      await _ns.subscribeToCategory(category);
    } else {
      await _ns.unsubscribeFromCategory(category);
    }
    setState(() => _loading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value
                ? 'Subscribed to $category events'
                : 'Unsubscribed from $category events',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade900.withValues(alpha: 0.15),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Choose which categories you want to be notified about when new events are posted.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          if (_loading)
            const LinearProgressIndicator(),
          Expanded(
            child: ListView.separated(
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isOn = _subscriptions[cat]!;
                return SwitchListTile(
                  title: Text(
                    cat,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    isOn
                        ? 'You will receive notifications for $cat events'
                        : 'Notifications off for $cat events',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOn ? Colors.green : Colors.grey,
                    ),
                  ),
                  secondary: Icon(
                    _getCategoryIcon(cat),
                    color: isOn ? Colors.blue : Colors.grey,
                  ),
                  value: isOn,
                  activeColor: Colors.blue,
                  onChanged: (val) => _toggle(cat, val),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school;
      case 'Sports':
        return Icons.sports_basketball;
      case 'Social':
        return Icons.people;
      case 'Arts':
        return Icons.palette;
      case 'Career':
        return Icons.work;
      default:
        return Icons.notifications;
    }
  }
}