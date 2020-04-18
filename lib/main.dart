import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Simple Diary';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      title: appTitle,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey[700],
          accentColor: Colors.yellowAccent,
          primaryColorBrightness: Brightness.dark),
      home: MyHomePage(title: appTitle, currentPage: 0),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final int currentPage;

  MyHomePage({Key key, this.title, this.currentPage}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(title, currentPage);
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editor;
  List<TxtClass> userData;

  int _currentPage;
  DateTime _selectedDate = new DateTime(new DateTime.now().year,
      new DateTime.now().month, new DateTime.now().day);

  _MyHomePageState(title, currentPage) {
    _currentPage = currentPage;
    editor = new TextEditingController(text: "");
  }

  Widget firstBody() {
    //because of formating
    var randomEmojisRaw =
        "🐜 🤗 🎨 🍒 🏆 🏈 💺 👢 ✒️ 🎽 👰 📚 ✂️ 🐻 🐴 🐫 🚄 😄 😜 🐄 🐵 🌻";
    var randomEmojis = randomEmojisRaw.split(' ');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<TxtClass> userD = await _loadJson(false);
      this.userData = userD;
      editor.text = '';
      for (var i = 0; i < userD.length; i++) {
        if (userD[i].date == _selectedDate.toString().split(' ')[0]) {
          editor.text = userD[i].text;
        }
      }
    });

    Widget retObj = new Column(children: <Widget>[
      new Center(
          child: new Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: new Text("Picked date: " +
                  _selectedDate
                      .toString()
                      .split(' ')[0]
                      .replaceAll('-', '/')))),
      new Expanded(
          child: Container(
        margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
        child: (new TextField(
          // alternative saving method
          // onChanged: (text) =>{
          // save after each char update here
          // },
          controller: editor,
          keyboardType: TextInputType.multiline,
          maxLines: 25,
          decoration: new InputDecoration(
            hintText: 'Write your story here ' +
                randomEmojis[Random().nextInt(randomEmojis.length)] +
                '...',
            fillColor: Colors.grey[900],
            filled: true,
          ),
        )),
      )),
      Center(
        child: RaisedButton(
          color: Theme.of(context).accentColor,
          textColor: Colors.black,
          onPressed: () {
            //search if date exists, then save, else append; When no text value found, remove entry.
            for (var i = 0; i < this.userData.length; i++) {
              if (this.userData[i].date ==
                  _selectedDate.toString().split(' ')[0]) {
                if (editor.text.isNotEmpty) {
                  this.userData[i].text = editor.text;
                  _saveJson();
                  return;
                } else {
                  this.userData.removeAt(i);
                  _saveJson();
                  return;
                }
              }
            }
            if (editor.text.isNotEmpty) {
              TxtClass temp = new TxtClass();
              temp.date = _selectedDate.toString().split(' ')[0];
              temp.text = editor.text;
              this.userData.add(temp);

              _saveJson();
            }
          },
          child: Text('Save entry'),
        ),
      ),
    ]);

    return retObj;
  }

  Widget secondBody() {
    Widget retObj = Align(
        alignment: Alignment.center,
        child: ListView(children: <Widget>[
          new Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: CalendarCarousel<Event>(
              onDayPressed: (DateTime date, List<Event> events) {
                this.setState(() => _selectedDate = date);
              },
              customDayBuilder: (
                /// you can provide your own build function to make custom day containers
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
              ) {
                //should've used more Iterables in other methods as well... ¯\_(ツ)_/¯
                if (this
                    .userData
                    .where((i) => i.date == day.toString().split(' ')[0])
                    .isNotEmpty) {
                  return Center(
                      child: ListView(
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        size: 15,
                        color: Colors.lightBlue,
                      ),
                      Center(child: Text(day.day.toString()))
                    ],
                  ));
                } else
                  return null;
              },
              minSelectedDate: new DateTime(1970),
              todayTextStyle: new TextStyle(color: Colors.lightBlue),
              todayBorderColor: Colors.lightBlue,
              todayButtonColor: Colors.transparent,
              selectedDayButtonColor: Color.fromRGBO(10, 10, 10, 0.4),
              selectedDayBorderColor: Colors.transparent,
              weekdayTextStyle:
                  new TextStyle(color: Theme.of(context).primaryColor),
              daysTextStyle: new TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
              thisMonthDayBorderColor: Color.fromRGBO(0, 0, 0, 0),
              firstDayOfWeek: 1,
              weekDayFormat: WeekdayFormat.short,
              weekFormat: false,
              height: 420.0,
              selectedDateTime: _selectedDate,
              daysHaveCircularBorder: true,
            ),
          ),
          new RaisedButton(
              onPressed: () {
                setState(() {
                  _currentPage = 0;
                });
              },
              child: Text('Edit / Add entry')),
        ]));

    return retObj;
  }

  Widget decideBody(index) {
    switch (index) {
      case 0:
        return firstBody();
        break;
      case 1:
        return secondBody();
        break;
      default:
        return firstBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    DrawerHeader sideBarHeader = new DrawerHeader(
        child: Text('Simple Diary App'),
        decoration: BoxDecoration(
            color: Colors.grey[700],
            //remove 'null)' and uncomment below; current image is a placeholder
            image: null)
        //new DecorationImage(
        //   // image: Image.network(
        //   //   'https://i.picsum.photos/id/270/400/200.jpg',
        //   // ).image,
        //   // fit: BoxFit.cover, )
        //   ),
        );

    List<Widget> sideBarEntrys() {
      List entrys = new List();
      entrys.add('Read/Write');
      entrys.add('Pick date');

      List<Widget> temp = new List();
      temp.add(sideBarHeader);
      for (var i = 0; i < entrys.length; i++) {
        temp.add(ListTile(
            title: Text(entrys[i]),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _currentPage = i;
              });
            }));
      }
      temp.add(Divider());
      temp.add(ListTile(
          title: Text("About Page"),
          onTap: () {
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          }));

      return temp;
    }

    return new Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: decideBody(_currentPage),
        drawer: new Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: sideBarEntrys(),
          ),
        ));
  }

  _saveJson() async {
    List<TxtClass> data = this.userData;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');
    String text = jsonEncode(data);
    await file.writeAsString(text);
    print('saved');
  }

  Future<List<TxtClass>> _loadJson(bool retry) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String data = await File('${directory.path}/data.json').readAsString();
      var txtobj = new List<TxtClass>();
      List jsonParsed = json.decode(data.toString());
      for (int i = 0; i < jsonParsed.length; i++) {
        txtobj.add(new TxtClass.fromJson(jsonParsed[i]));
      }

      return txtobj;
    } catch (e) {
      print(e.toString() + "\nwill try to create new file");
      this.userData = new List<TxtClass>();
      await _saveJson();
      return (!retry) ? _loadJson(true) : null;
    }
  }
}

class TxtClass {
  String date;
  String text;

  TxtClass({this.date, this.text});

  factory TxtClass.fromJson(Map<String, dynamic> json) {
    return new TxtClass(
        date: json['date'] as String, text: json['text'] as String);
  }
  Map<String, dynamic> toJson() => {"date": this.date, "text": this.text};
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About"),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          new Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
                "Programmed by © getraid 2020\ngit.getraid.com\n\nMade with Flutter\n\nDependecies:\nflutter_calendar_carousel: MIT\npath_provider: BSD\n\nLicense: MIT"),

            // Center(
            //     child: RaisedButton(
            //   onPressed: () {

            //   },
            //   child: Text('Export JSON'),
            // )
            // )
          ])
        ]));
  }
}
