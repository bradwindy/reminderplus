import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reminder_plus/database/database_helper.dart';
import 'package:reminder_plus/database/model/reminder.dart';

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
  final editReminderText = TextEditingController();
  DateTime selectedDate;
  TimeOfDay selectedTime;
  String selectedCategory;
  DateTime finalDate;
  String saveText = "";
  bool prevInit = false;

  final FocusNode _focusNode = FocusNode();

  List monthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  List weekdayList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  Future<Null> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 100));

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101)
    );

    setState(() {
      selectedDate = picked;
      print(selectedDate.toIso8601String());
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 100));

    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime
    );


    setState(() {
      selectedTime = pickedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEdit && widget.reminder == null) {
      //So I can build buttons with these default values
      widget.reminder = new Reminder("", DateTime.now().millisecondsSinceEpoch, "Inbox");
      selectedDate = new DateTime.fromMillisecondsSinceEpoch(widget.reminder.date);
      selectedTime = new TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute);
    }

    editReminderText.text = saveText;
    selectedCategory = widget.reminder.category;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.isEdit ? 'Edit' : 'Add new Reminder'),
      ),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32.0),
              child: getTextField("Enter Text:", editReminderText),
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
                            Text(weekdayList[selectedDate.weekday-1] + " " + selectedDate.day.toString() + " " + monthList[selectedDate.month-1],
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
                            Text(selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
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
                      MaterialButton(
                        onPressed: () {
                          //_selectDate(context);
                        },
                        child: Row( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Text("Personal",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            Icon(Icons.keyboard_arrow_right, color: Colors.pink),
                          ],
                        ),
                        //color: Colors.pink,
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
        finalDate = new DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute),
        //TODO this line below does not work if the user has not selected a date or time, so to fix this,
        // need to have and option where the user doesn't need to choose a date or time
        // could do this by setting the date and time values to null first rather than to the current time?
        widget.reminder = new Reminder(saveText, finalDate.millisecondsSinceEpoch, selectedCategory),
        addRecord(widget.isEdit, widget.reminder),
        Navigator.pop(context),
        },
        tooltip: 'Done',
        icon: Icon(Icons.done),
        label: const Text('Done'),
      ),
    );
  }

  Widget getTextField(
    String inputBoxName, TextEditingController inputBoxController) {
    var textBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextField(
        controller: inputBoxController,
        focusNode: _focusNode,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
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

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        saveText = editReminderText.text;
        print(saveText);
      }
    });
  }
}
