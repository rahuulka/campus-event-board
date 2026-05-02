import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground message: ${message.notification?.title}');
    });
  }

  Future<void> subscribeToCategory(String category) async {
    await _fcm.subscribeToTopic(category.toLowerCase());
  }

  Future<void> unsubscribeFromCategory(String category) async {
    await _fcm.unsubscribeFromTopic(category.toLowerCase());
  }
}