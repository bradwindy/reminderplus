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
        brightness: Brightness.light,
        accentColor: Colors.pink,
        accentColorBrightness: Brightness.dark,
        primaryColor: Colors.pink,
      ),
      home: new MyHomePage(title: 'Reminder+'),
    );
  }

}
