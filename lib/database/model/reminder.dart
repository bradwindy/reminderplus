class Reminder {

  int id;
  String _text;
  //DateTime _date;

  Reminder(this._text);

  Reminder.map(dynamic obj) {
    this._text = obj["text"];
    //this._date = obj["date"];
  }

  String get text => _text;
  //DateTime get date => _date;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["text"] = _text;
    return map;
  }

  void setReminderId(int id) {
    this.id = id;
  }
}
