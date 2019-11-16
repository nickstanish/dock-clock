import 'dart:async';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';

void main() => runApp(MyApp());

//const TIME_FORMAT_WITH_SECONDS_STRING = 'hh:mm:ss a';
const TIME_FORMAT_STRING = 'hh:mm';
const AM_PM_FORMAT_STRING = 'a';
const DATE_FORMAT_STRING = 'EEEE, MMMM d, yyyy';

final DateFormat timeFormatter = new DateFormat(TIME_FORMAT_STRING);
final DateFormat ampmFormatter = new DateFormat(AM_PM_FORMAT_STRING);
final DateFormat dateFormatter = new DateFormat(DATE_FORMAT_STRING);

const DAY_TIME = [9, 21];
const DAY_BRIGHTNESS = 1.0;
const NIGHT_BRIGHTNESS = 0.0;

// https://proandroiddev.com/how-to-dynamically-change-the-theme-in-flutter-698bd022d0f0
final nightTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    canvasColor: Colors.black,
    textTheme: TextTheme(
        headline: TextStyle(color: Colors.white, fontSize: 92),
        subhead: TextStyle(color: Colors.white, fontSize: 20),
        subtitle: TextStyle(color: Colors.white, fontSize: 38)
    )
);

final dayTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    canvasColor: Color.fromRGBO(193, 246, 244, 1),
    textTheme: TextTheme(
        headline: TextStyle(color: Colors.black, fontSize: 92),
        subhead: TextStyle(color: Colors.black, fontSize: 20),
        subtitle: TextStyle(color: Colors.black, fontSize: 38)
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
    SystemChrome.setEnabledSystemUIOverlays([]);
    Screen.keepOn(true);

    timer = new Timer.periodic(Duration(seconds: 1), (Timer t) => setState((){
      _time = new DateTime.now();
      if (_time.hour < DAY_TIME[0] || _time.hour > DAY_TIME[1]) {
        widget.setNightMode(true);
        Screen.setBrightness(NIGHT_BRIGHTNESS);
      } else {
        widget.setNightMode(false);
        Screen.setBrightness(DAY_BRIGHTNESS);
      }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        timeFormatter.format(_time),
                        style: Theme.of(context).textTheme.headline
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 2.0),
                        child: Text(
                            ampmFormatter.format(_time),
                            style: Theme.of(context).textTheme.subtitle
                        )
                    )
                  ]
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
