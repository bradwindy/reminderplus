import 'package:flutter/material.dart';
import 'package:reminder_plus/database/model/reminder.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class SettingsPage extends StatefulWidget {
  Reminder reminder;
  bool isEdit;

  SettingsPage() {
    //
  }

  @override
  State<StatefulWidget> createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            ListTile(
              title: Text(
                "Test Notification!",
              ),
              subtitle: Text(
                "Tap me to recieve a test notification :)",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              leading: Icon(
                OMIcons.notificationsActive,
              ),
            ),
          ],
        ));
  }
}
