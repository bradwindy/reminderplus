import 'package:flutter/material.dart';
import 'package:reminder_plus/homescreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Reminder+',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.pink,
        accentColorBrightness: Brightness.dark,
      ),
      home: new MyHomePage(title: 'Reminder+'),
    );
  }

}
