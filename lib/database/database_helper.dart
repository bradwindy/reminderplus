import 'dart:async';
import 'dart:io' as io;
import 'package:reminder_plus/database/model/reminder.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Reminders(id INTEGER PRIMARY KEY, text TEXT, date INTEGER, category TEXT)");
  }

  Future<int> saveReminder(Reminder reminder) async {
    var dbClient = await db;
    int res = await dbClient.insert("Reminders", reminder.toMap());
    return res;
  }

  Future<List<Reminder>> getReminder() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Reminders');
    List<Reminder> reminders = new List();

    for (int i = 0; i < list.length; i++) {
      var reminder = new Reminder(list[i]["text"],list[i]["date"],list[i]["category"]);
      reminder.setReminderId(list[i]["id"]);
      reminders.add(reminder);
    }

    print(reminders.length);
    return reminders;
  }

  Future<int> deleteReminders(Reminder reminder) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM Reminders WHERE id = ?', [reminder.id]);

    return res;
  }

  Future<bool> update(Reminder reminder) async {
    var dbClient = await db;
    int res =   await dbClient.update("Reminders", reminder.toMap(), where: "id = ?", whereArgs: <int>[reminder.id]);

    return res > 0 ? true : false;
  }
}
