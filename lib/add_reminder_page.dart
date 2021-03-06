import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reminder_plus/database/database_helper.dart';
import 'package:reminder_plus/database/model/reminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_plus/change_categories_page.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


class AddReminderPage extends StatefulWidget {
  Reminder reminder;
  bool isEdit;

  AddReminderPage(bool isEdit, Reminder reminder) {
    this.isEdit = isEdit;
    this.reminder = reminder;
  }

  @override
  State<StatefulWidget> createState() => new _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage>{
  DateTime selectedDate;
  TimeOfDay selectedTime;
  String selectedCategory = "Inbox";
  DateTime finalDate;
  String saveText = "";
  bool prevInit = false;
  bool timeOrDateEdit = false;
  List monthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  List weekdayList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  List categories = [
    "+ Add Category",
    "Inbox",
    "Personal",
    "Work",
    "University"
  ];

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

  Future<Null> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 100));

    DateTime initDate = selectedDate;

    if(selectedDate == null){
      initDate = DateTime.now();
    }

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101)
    );

    setState(() {
      selectedDate = picked;
      timeOrDateEdit = true;
      //print(selectedDate.toIso8601String());
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 100));

    TimeOfDay initTime = selectedTime;

    if(selectedTime == null){
      initTime = TimeOfDay.now();
    }

    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: initTime,
    );


    setState(() {
      selectedTime = pickedTime;
      timeOrDateEdit = true;
    });
  }

  DateTime constructDate(DateTime date, TimeOfDay time){
    if (date == null){
      return null;
    }

    if (date != null && time == null){
      return new DateTime(date.year, date.month, date.day);
    }

    return new DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  int finalDateInt (DateTime date){
    if (date != null){
      return date.millisecondsSinceEpoch;
    }
    return null;
  }

  Future onSelectNotification(String payload) {

  }

  Future onDidReceiveLocalNotification(int hi, String one, String two,
      String three) {

  }

  Future<void> scheduledTestNotification(String contents, String category,
      DateTime date) async {
    var scheduledNotificationDateTime = date;

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
        contents,
        category,
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'item x'
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEdit && widget.reminder == null && timeOrDateEdit == false) {
      //So I can build buttons with these default values
      widget.reminder = new Reminder("", null, "Inbox");
      selectedDate = null;
      selectedTime = null;
      print("HIT FIRST IF");
    }


    String displayDate = "None";
    String displayTime = "None";

    if(selectedDate != null){
      displayDate = weekdayList[selectedDate.weekday-1] + " " + selectedDate.day.toString() + " " + monthList[selectedDate.month-1];
    }

    if(selectedTime != null){
      String hourTemp = selectedTime.hour.toString();
      String minTemp = selectedTime.minute.toString();

      if (hourTemp.length == 1){
        hourTemp = "0" + hourTemp;
      }
      if (minTemp.length == 1){
        minTemp = "0" + minTemp;
      }

      displayTime = hourTemp + ":" + minTemp;
    }

    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.grey[700]),
        title: new Text(widget.isEdit ? 'Edit' : 'Add new Reminder',
            style: TextStyle(color: Colors.grey[700])),
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32.0),
              child: getTextField("Enter Text:"),
            ),

            Padding(
              padding: EdgeInsets.only(top:32.0, right:32.0, bottom:32.0, left:52.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Select Date: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      MaterialButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Row( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            //day number month
                            Text(displayDate,
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            Icon(Icons.keyboard_arrow_right, color: Colors.pink),
                          ],
                        ),
                        //color: Colors.pink,
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Select Time:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      MaterialButton(
                        onPressed: () {
                          _selectTime(context);
                        },
                        child: Row( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Text(displayTime,
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            Icon(Icons.keyboard_arrow_right, color: Colors.pink),
                          ],
                        ),
                        //color: Colors.pink,
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Select Category: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          onChanged: (String newValue) {
                            if (newValue == "+ Add Category") {
                              _showFeatureDialog();
                            } else {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            }
                          },
                          items: categories
                              .cast<String>()
                              .map((value) =>
                              DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              )).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

      ),



      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          _showNoDateDialog(context),
        },
        tooltip: 'Done',
        icon: Icon(Icons.done),
        label: const Text('Done'),
      ),
    );
  }

  void _showNoDateDialog(BuildContext context) {
    if ((selectedDate == null && selectedTime != null) ||
        (selectedDate != null && selectedTime == null)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Oops!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Date and time must both be selected for a notification to occur',
                    style: TextStyle(fontStyle: FontStyle.italic),),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('GO BACK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }else if(saveText == null || saveText == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Oops!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You have not chosen any text for the reminder!',
                    style: TextStyle(fontStyle: FontStyle.italic),),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('GO BACK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }else{
      finalDate = constructDate(selectedDate, selectedTime);
      widget.reminder = new Reminder(saveText, finalDateInt(finalDate), selectedCategory);
      addRecord(widget.isEdit, widget.reminder);

      //TODO if statement for if date and time are NULL

      if (finalDate != null) {
        scheduledTestNotification(saveText, selectedCategory, finalDate);
      }

      Navigator.pop(context);
    }
  }

  Widget getTextField(String inputBoxName) {
    var textBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextField(
        decoration: new InputDecoration(hintText: inputBoxName),
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (text) => saveText = text,
      ),
    );
    return textBtn;
  }

  Future addRecord(bool isEdit, Reminder reminder) async {
    var db = new DatabaseHelper();
    if (isEdit){
      reminder.setReminderId(widget.reminder.id);
      await db.update(reminder);
    }else{
      await db.saveReminder(reminder);
    }
  }

  void _showFeatureDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Feature Coming Soon'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This feature will be here in the near future.',
                  style: TextStyle(fontStyle: FontStyle.italic),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OKAY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
