class Reminder {

  int id;
  String _text;
  int _date;
  String _category;

  Reminder(this._text, this._date, this._category);

  Reminder.map(dynamic obj) {
    this._text = obj["text"];
    this._date = obj["date"];
    this._category= obj["category"];
  }

  String get text => _text;
  int get date => _date;
  String get category => _category;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["text"] = _text;
    map["date"] = _date;
    map["category"] = _category;
    return map;
  }

  void setReminderId(int id) {
    this.id = id;
  }
}
