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
    accentColor: Colors.yellowAccent,),
      home: MyHomePage(title: appTitle, currentPage: 1),
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
  // String _title;
  int _currentPage;
  _MyHomePageState(title, currentPage) {
    //  _title = title;
    _currentPage = currentPage;
  }

  Widget firstBody() {
    Widget retObj = Center(child: Text('This is Page ' + _currentPage.toString()));

    return retObj;
  }

  Widget secondBody() {
    Widget retObj = Align(
        alignment: Alignment.centerRight,
        child: Text('You are on Page ' + _currentPage.toString()));

    return retObj;
  }

  Widget decideBody(index) {
    switch (index) {
      case 1:
        return firstBody();
        break;
      case 2:
        return secondBody();
        break;
      default:
        return firstBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: decideBody(_currentPage),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
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
                ),
            ListTile(
              title: Text('Read/Write'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentPage = 1;
                });
              },
            ),
            ListTile(
              title: Text('Pick date'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentPage = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
