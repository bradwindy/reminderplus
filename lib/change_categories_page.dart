import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class ChangeCategoriesPage extends StatefulWidget {
  ChangeCategoriesPage() {
    //
  }

  @override
  State<StatefulWidget> createState() => new _ChangeCategoriesPageState();
}

class _ChangeCategoriesPageState extends State<ChangeCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.grey[700]),
        title: new Text('Settings', style: TextStyle(color: Colors.grey[700])),
        backgroundColor: Colors.white,
      ),
    );
  }
}
