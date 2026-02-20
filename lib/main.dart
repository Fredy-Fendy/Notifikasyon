import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

final notifications = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings(requestAlertPermission: true);
  await notifications.initialize(const InitializationSettings(android: android, iOS: ios));
  
  await notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel('channel', 'Notifications', importance: Importance.max));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotificationDemo(),
  );
}

class NotificationDemo extends StatefulWidget {
  const NotificationDemo({super.key});
  @override
  State<NotificationDemo> createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo> {
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _show(int id, String title, String body, {List<AndroidNotificationAction>? actions}) async {
    await notifications.show(id, title, body, NotificationDetails(
      android: AndroidNotificationDetails(
        'channel',
        'Notifications',
        importance: Importance.max,
        priority: Priority.high,
        actions: actions,
      ),
      iOS: const DarwinNotificationDetails(),
    ));
  }

  Future<void> _immediate() => _show(1, 'Imedya', 'Notifikasyon imedya!');

  Future<void> _scheduled() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ap tann 10 segonn...')));
    await Future.delayed(const Duration(seconds: 10));
    if (mounted) await _show(2, 'Pwograme', 'Apre 10 segonn!');
  }
  Future<void> _action() async {
    await _show(
      4,
      'Ak Aksyon',
      'Ou dakò?',
      actions: const [
        AndroidNotificationAction('yes', 'Wi'),
        AndroidNotificationAction('no', 'Non'),
      ],
    );
  }

  Future<void> _repeating() async {
    await _show(3, 'Repete #1', 'Premye notifikasyon');
    timer?.cancel();
    timer = Timer.periodic(const Duration(minutes: 1), (t) {
      if (mounted) _show(3, 'Repete #${t.tick + 1}', 'Chak minit');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('TP Notifikasyon', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.black, foregroundColor: Colors.white),
    body: Padding(padding: const EdgeInsets.all(30), child: ListView(children: [
      const SizedBox(height: 120),
      _btn('Notifikasyon imedya', Colors.black, _immediate),
      _btn('Notifikasyon pwograme', Colors.grey.shade700, _scheduled),
      _btn('Notifikasyon repete', Colors.black, _repeating),
      _btn('Notifikasyon ak bouton', Colors.grey.shade700, _action),
    ])),
  );

  Widget _btn(String t, Color c, VoidCallback f) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(30)),
    child: Material(color: Colors.transparent, child: InkWell(
      onTap: f,
      borderRadius: BorderRadius.circular(30),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Expanded(child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 16))), const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)],
      )),
    )),
  );
}