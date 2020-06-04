
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

  final mainItems = [
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

  final fabItems = [
    RadialMenuItem(Icon(FontAwesome.glass, color: Colors.white), Colors.red,
        () => print('red')),
    RadialMenuItem(Icon(FontAwesome.glass, color: Colors.white), Colors.green,
        () => print('green')),
    RadialMenuItem(Icon(FontAwesome.glass, color: Colors.white), Colors.blue,
        () => print('blue')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: RadialMenu(mainItems, isClockwise: false,)),
      floatingActionButton: RadialMenu(fabItems, fanout: Fanout.topLeft,),
    );
  }
}
