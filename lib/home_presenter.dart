import 'package:reminder_plus/database/database_helper.dart';
import 'package:reminder_plus/database/model/reminder.dart';
import 'dart:async';

abstract class HomeContract {
  void screenUpdate();
}

class HomePresenter {
  HomeContract _view;
  var db = new DatabaseHelper();
  HomePresenter(this._view);

  delete(Reminder reminder) {
    var db = new DatabaseHelper();
    db.deleteReminders(reminder);
    updateScreen();
  }

  Future<List<Reminder>> getReminder() {
    return db.getReminder();
  }

  updateScreen() {
    _view.screenUpdate();

  }
}
