import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class SettingsPage extends StatefulWidget {
  SettingsPage() {
    //
  }

  @override
  State<StatefulWidget> createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid,
        initializationSettingsIOS
    );

    flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.grey[700]),
          title: new Text(
              'Settings', style: TextStyle(color: Colors.grey[700])),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            ListTile(
              title: Text(
                "Test Notification!",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              subtitle: Text(
                "Tap me to recieve a test notification :)",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              leading: Icon(
                OMIcons.notificationsActive,
              ),
              onTap: () async {
                await testNotification();
              },
            ),

            ListTile(
              title: Text(
                "Scheduled Test Notification",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              subtitle: Text(
                "Tap to recieve a scheduled test notification",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              leading: Icon(
                OMIcons.notificationsActive,
              ),
              onTap: () async {
                await scheduledTestNotification();
              },
            ),
          ],
        ));
  }

  Future onSelectNotification(String payload) {

  }

  Future onDidReceiveLocalNotification(int hi, String one, String two,
      String three) {

  }

  Future<void> testNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'ReminderChannel',
        'Reminders',
        'Reminder Notifications',
        icon: 'secondary_icon',
        color: const Color.fromARGB(255, 255, 0, 164),
        ledColor: const Color.fromARGB(255, 255, 0, 164),
        ledOnMs: 1000,
        ledOffMs: 1000
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics,
        iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.show(
        0,
        'Test Notification',
        'This is a test notification 🛠',
        platformChannelSpecifics,
        payload: 'item x'
    );
  }

  Future<void> scheduledTestNotification() async {
    var scheduledNotificationDateTime = DateTime.now().add(
        Duration(seconds: 10));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'ReminderChannel',
        'Reminders',
        'Reminder Notifications',
        icon: 'secondary_icon',
        color: const Color.fromARGB(255, 255, 0, 164),
        ledColor: const Color.fromARGB(255, 255, 0, 164),
        ledOnMs: 1000,
        ledOffMs: 1000
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics,
        iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Test Notification',
        'This is a test notification 🛠',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'item x'
    );
  }

}
