import 'dart:math';
import 'package:flutter/material.dart';

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
    editor = new TextEditingController(text: "d");
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
          maxLines: 20,
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
