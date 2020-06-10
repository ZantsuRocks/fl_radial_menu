import 'package:fl_radial_menu/fl_radial_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final items = [
    RadialMenuItem(Icon(FontAwesome.glass, color: Colors.white), Colors.red,
        () => print('red')),
    RadialMenuItem(Icon(FontAwesome.glass, color: Colors.white), Colors.green,
        () => print('green')),
    RadialMenuItem(Icon(FontAwesome.glass, color: Colors.white), Colors.blue,
        () => print('blue')),
    RadialMenuItem(Icon(FontAwesome.glass, color: Colors.white), Colors.yellow,
        () => print('yellow')),
    RadialMenuItem(Icon(FontAwesome.glass, color: Colors.white), Colors.purple,
        () => print('purple')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(children: [
          RadialMenu(items, fanout: Fanout.bottomRight),
          Container(child: RadialMenu(items, fanout: Fanout.bottom)),
          RadialMenu(
            items,
            fanout: Fanout.bottomLeft,
          ),
          RadialMenu(items, fanout: Fanout.right),
          RadialMenu(items),
          RadialMenu(items, fanout: Fanout.left),
          RadialMenu(items, fanout: Fanout.topRight),
          RadialMenu(items, fanout: Fanout.top),
          RadialMenu(items, fanout: Fanout.topLeft),
        ]),
      ),
      floatingActionButton: RadialMenu(
        items,
        fanout: Fanout.topLeft,
      ),
    );
  }
}
