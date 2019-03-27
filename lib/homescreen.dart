import 'package:flutter/material.dart';
import 'package:reminder_plus/add_reminder_page.dart';
import 'package:reminder_plus/database/model/reminder.dart';
import 'package:reminder_plus/home_presenter.dart';
import 'package:reminder_plus/list.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements HomeContract {
  HomePresenter homePresenter;

  @override
  void initState() {
    super.initState();
    homePresenter = new HomePresenter(this);
  }

 /* List<Widget> _buildActions() {
    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
        onPressed: () => AddReminderPage().buildAboutDialog(context, this, false, null),
      ),
    ];
  }*/

  showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {

        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: (72 * 5).toDouble(),
                child: Container(
                  decoration: BoxDecoration(
                    //color: Colors.white,
                  ),
                  child: Stack(
                    alignment: Alignment(0, 0),
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "Categories",
                              ),
                              subtitle: Text(
                                "Coming Soon",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              leading: Icon(
                                Icons.folder_special,
                              ),
                              onTap: () {},
                            ),

                            ListTile(
                              title: Text(
                                "Completed",
                              ),
                              subtitle: Text(
                                "Coming Soon",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              leading: Icon(
                                Icons.done_all,
                              ),
                              onTap: () {},
                            ),

                            ListTile(
                              title: Text(
                                "Account",
                              ),
                              subtitle: Text(
                                "Coming Soon",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              leading: Icon(
                                Icons.account_circle,
                              ),
                              onTap: () {},
                            ),

                            ListTile(
                              title: Text(
                                "Help",
                              ),
                              subtitle: Text(
                                "Coming Soon",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              leading: Icon(
                                Icons.help,
                              ),
                              onTap: () {},
                            ),

                            ListTile(
                              title: Text(
                                "Settings",
                              ),
                              subtitle: Text(
                                "Coming Soon",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              leading: Icon(
                                Icons.settings,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Reminder+'),
        // actions: _buildActions(),
      ),

      body: new FutureBuilder<List<Reminder>>(
        future: homePresenter.getReminder(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          var data = snapshot.data;
          return snapshot.hasData
            ? new ReminderList(data,homePresenter)
            : new Center(child: new CircularProgressIndicator());
        },
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => AddReminderPage(false, new Reminder("")),
          ),
        ),
        tooltip: 'New Reminder',
        icon: Icon(Icons.add),
        label: const Text('Add Reminder'),
      ),

      bottomNavigationBar: BottomAppBar(
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: showMenu,
                    icon: Icon(Icons.menu),
                  ),
                  Text('Menu', style: TextStyle(fontWeight: FontWeight.bold)),
                  //Text('Reminder', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(right: 10.0, top: 5, bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Inbox', style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.inbox),
                    onPressed: () {
                      _showFeatureDialog();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Feature Coming Soon :)'),
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

  @override
  void screenUpdate() {
    setState(() {});
  }
}
