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

  List monthList = ["Jan", "Feb", "March", "April", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"];
  List weekdayList = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  int selectedMonth;
  String selectedDay;
  int selectedWeekday;

  String selectedCategory = "Inbox";

  Future<Null> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 100));

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101)
    );

    /*if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selectedMonth = selectedDate.month.toInt() - 1;
        selectedDay = selectedDate.day.toString();
        selectedWeekday = selectedDate.weekday.toInt() - 1;
      });*/
  }

  Future<Null> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await Future.delayed(Duration(milliseconds: 100));

    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime
    );

    /*if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
        booking += (" " + selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
        _addTodoItem(booking);
      });*/
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEdit) {
      //So I can build buttons with these default values
      widget.reminder= new Reminder("", DateTime.now(), "Inbox");
    }

    editReminderText.text = widget.reminder.text;
    selectedDate = widget.reminder.date;

    // TODO construct time from date here here


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
                            // TODO FORMAT DATE HERE FROM SELECTED DATE
                            Text("Monday 25th March",
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
                      Text('Select Time: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      MaterialButton(
                        onPressed: () {
                          _selectTime(context);
                        },
                        child: Row( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            // TODO FORMAT TIME HERE FROM SELECTED TIME
                            Text("8:00PM",
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
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
    return textBtn;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,

      decoration: new BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),

      child: new Text(
        buttonLabel,
        style: new TextStyle(
          color: const Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }

  Future addRecord(bool isEdit, Reminder reminder) async {
    var db = new DatabaseHelper();

    //TODO ADD SELECTED TIME TO DATE HERE
    //TODO check these work
    var reminder = new Reminder(editReminderText.text, selectedDate, selectedCategory);

    if (isEdit){
      reminder.setReminderId(widget.reminder.id);
      await db.update(reminder);
    }else{
      await db.saveReminder(reminder);
    }
  }
}
