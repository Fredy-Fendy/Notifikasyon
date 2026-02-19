import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notifPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android, iOS: DarwinInitializationSettings());
  await notifPlugin.initialize(settings);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'TP Notifikasyon',
    home: const HomePage(),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showInstant() => notifPlugin.show(1, 'Imedya', 'Notifikasyon imedya!', 
      const NotificationDetails(android: AndroidNotificationDetails('ch1', 'Imedya')));

  void _showScheduled() {
    final date = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    notifPlugin.zonedSchedule(2, 'Pwograme', 'Apre 5 segonn', date,
        const NotificationDetails(android: AndroidNotificationDetails('ch2', 'Pwograme')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  void _showRepeating() => notifPlugin.periodicallyShow(3, 'Repete', 'Chak èdtan',
      RepeatInterval.hourly, const NotificationDetails(android: AndroidNotificationDetails('ch3', 'Repete')));

  void _showAction() => notifPlugin.show(4, 'Ak Aksyon', 'Wi oswa Non?',
      const NotificationDetails(android: AndroidNotificationDetails('ch4', 'Aksyon', actions: [
        AndroidNotificationAction('yes', 'Wi'), AndroidNotificationAction('no', 'Non')])));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('TP Notifikasyon', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black, foregroundColor: Colors.white),
    body: Padding(
      padding: const EdgeInsets.all(30),
      child: ListView(children: [
        const SizedBox(height: 120),
        _btn('Notifikasyon imedya', Colors.black, _showInstant),
        _btn('Notifikasyon pwograme', Colors.grey.shade700, _showScheduled),
        _btn('Notifikasyon repete', Colors.black, _showRepeating),
        _btn('Notifikasyon ak bouton', Colors.grey.shade700, _showAction),
      ]),
    ),
  );

  Widget _btn(String t, Color c, VoidCallback f) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(30)),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: f,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 16))),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ]),
        ),
      ),
    ),
  );
}