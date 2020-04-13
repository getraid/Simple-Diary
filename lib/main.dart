import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Simple Diary';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[700],
        accentColor: Colors.yellowAccent,
      ),
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
  // String _title;
  int _currentPage;
  DateTime _selectedDate = new DateTime(new DateTime.now().year,
      new DateTime.now().month, new DateTime.now().day);

  _MyHomePageState(title, currentPage) {
    //  _title = title;
    _currentPage = currentPage;
    editor = new TextEditingController(text: "");
  }

  Widget firstBody() {
    //because of formating
    var randomEmojisRaw =
        "🐜 🤗 🎨 🍒 🏆 🏈 💺 👢 ✒️ 🎽 👰 📚 ✂️ 🐻 🐴 🐫 🚄 😄 😜 🐄 🐵 🌻";
    var randomEmojis = randomEmojisRaw.split(' ');

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
          controller: editor,
          keyboardType: TextInputType.multiline,
          maxLines: 28,
          decoration: new InputDecoration(
            hintText: 'Write your story here ' +
                randomEmojis[Random().nextInt(randomEmojis.length)] +
                '...',
            fillColor: Colors.grey[900],
            filled: true,
          ),
        )),
      ))
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
                /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
                /// This way you can build custom containers for specific days only, leaving rest as default.

                // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
                if (day.day == 13) {
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
                } else {
                  return null;
                }
              },
              todayTextStyle:
                  new TextStyle(color: Colors.lightBlue),
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
                _selectedDate = new DateTime(2019, 01, 01);
              },
              child: Text('Change!')),
          RichText(text: TextSpan(text: editor.text))
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

    //
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
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
