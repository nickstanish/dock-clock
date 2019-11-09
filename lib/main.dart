import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';

void main() => runApp(MyApp());

const TIME_FORMAT_STRING = 'hh:mm:ss a';
const DATE_FORMAT_STRING = 'EEEE, MMMM d, yyyy';

final DateFormat timeFormatter = new DateFormat(TIME_FORMAT_STRING);
final DateFormat dateFormatter = new DateFormat(DATE_FORMAT_STRING);

const DAY_TIME = [8, 21];

// https://proandroiddev.com/how-to-dynamically-change-the-theme-in-flutter-698bd022d0f0
final nightTheme = ThemeData(
  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.
    primarySwatch: Colors.blueGrey,
    canvasColor: Colors.black,
    textTheme: TextTheme(
        headline: TextStyle(color: Colors.white, fontSize: 80), subhead: TextStyle(color: Colors.white, fontSize: 20)
    )
);

final dayTheme = ThemeData(
  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.
    primarySwatch: Colors.blueGrey,
    canvasColor: Colors.lightBlueAccent,
    textTheme: TextTheme(
        headline: TextStyle(color: Colors.black, fontSize: 80), subhead: TextStyle(color: Colors.black, fontSize: 20)
    )
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool nightMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dock Clock',
        theme: nightMode ? nightTheme : dayTheme,
        home: MyHomePage(title: 'Dock Clock', setNightMode: (nightModeValue) {
          setState(() {
            nightMode = nightModeValue;
          });
        })
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.setNightMode}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Function(bool) setNightMode;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _time = new DateTime.now();
  Timer timer;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    Screen.setBrightness(0.1);
    timer = new Timer.periodic(Duration(seconds: 1), (Timer t) => setState((){
      _time = new DateTime.now();
      widget.setNightMode(_time.hour < DAY_TIME[0] || _time.hour > DAY_TIME[1]);
    }));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
        child: Scaffold(
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    timeFormatter.format(_time),
                  style: Theme.of(context).textTheme.headline
                ),
                Text(
                    dateFormatter.format(_time),
                    style: Theme.of(context).textTheme.subhead
                )
              ],
            ),
          ),
        )
    );
  }
}
