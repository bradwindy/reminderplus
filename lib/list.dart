import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reminder_plus/database/model/reminder.dart';
import 'package:reminder_plus/home_presenter.dart';

class ReminderList extends StatelessWidget {
  final List<Reminder> reminders;
  final HomePresenter homePresenter;

  ReminderList(
    this.reminders,
    this.homePresenter, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List monthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    List weekdayList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

    return new ListView.builder(
      itemCount: reminders == null ? 0 : reminders.length,
      itemBuilder: (BuildContext context, int index) {

        return new CheckboxListTile(
          title: new Text(reminders[index].text),
          subtitle: new Text(
                      weekdayList[new DateTime.fromMillisecondsSinceEpoch(reminders[index].date).weekday-1]
              + " " + new DateTime.fromMillisecondsSinceEpoch(reminders[index].date).day.toString()
              + " " + monthList[new DateTime.fromMillisecondsSinceEpoch(reminders[index].date).month-1]
              + " " + new DateTime.fromMillisecondsSinceEpoch(reminders[index].date).hour.toString()
              + ":" + new DateTime.fromMillisecondsSinceEpoch(reminders[index].date).minute.toString()
              + ", " + reminders[index].category),
          value: false,
          onChanged: (bool value) => homePresenter.delete(reminders[index]),
        );

        /*return new Card(
          child: new Container(
            child: new Center(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            reminders[index].text, //+ " " + reminders[index].lastName,
                            // set some style to text
                            style: new TextStyle(
                                fontSize: 20.0,
                                ),
                          ),

                          *//*new Text(
                            "DATE: " + reminders[index].dob,
                            // set some style to text
                            style: new TextStyle(
                                fontSize: 20.0, color: Colors.amber),
                          ),*//*

                        ],
                      ),
                    ),
                  ),

                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new IconButton(
                        icon: const Icon(
                          Icons.edit,
                          //color: const Color(0xFF167F67),
                        ),
                        onPressed: () => edit(reminders[index], context),
                      ),

                      new IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          //color: const Color(0xFF167F67)
                        ),
                        onPressed: () => homePresenter.delete(reminders[index]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
        );*/
      }
    );
  }

  displayRecord() {
    homePresenter.updateScreen();
  }

  /*edit(Reminder reminder, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new AddReminderPage(true, reminder),
    );
    homePresenter.updateScreen();
  }*/

  String getShort(Reminder reminder) {
    String short = "";

    if (reminder.text.isNotEmpty) {
      short = reminder.text.substring(0, 1) + ".";
    }

    return short;
  }
}
