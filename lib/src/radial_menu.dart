import 'dart:math';

import 'package:flutter/material.dart';
import 'radial_menu_item.dart';

enum Direction {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  top,
  bottom,
  left,
  right,
  circle,
}

class RadialMenu extends StatefulWidget {
  final List<RadialMenuItem> items;
  final double childDistance;
  final double iconRadius;
  final double mainButtonRadius;
  final bool isClockwise;
  final int dialOpenDuration;
  final Curve curve;
  final Direction area;
  double get containersize => (childDistance + iconRadius) * (2 + 0.1); // consider animation overshoot

  int get startAngle {
    switch (area) {
      case Direction.topLeft:
        return isClockwise ? 180 : 90;
        break;
      case Direction.topRight:
        return isClockwise ? 270 : 0;
        break;
      case Direction.bottomLeft:
        return isClockwise ? 90 : 180;
        break;
      case Direction.bottomRight:
        return isClockwise ? 0 : 270;
        break;
      case Direction.top:
        return isClockwise ? 180 : 0;
        break;
      case Direction.bottom:
        return isClockwise ? 0 : 180;
        break;
      case Direction.left:
        return 90;
        break;
      case Direction.right:
        return 270;
        break;
      case Direction.circle:
        return 0;
        break;
    }
    return 0;
  }

  int get angularWidth {
    switch (area) {
      case Direction.topLeft:
      case Direction.topRight:
      case Direction.bottomLeft:
      case Direction.bottomRight:
        return 90;
        break;
      case Direction.top:
      case Direction.bottom:
      case Direction.left:
      case Direction.right:
        return 180;
        break;
      case Direction.circle:
        return 360;
        break;
    }
    return 0;
  }

  int get numDivide {
    if (angularWidth == 360.0) {
      return items.length;
    } else {
      return items.length - 1;
    }
  }

  final _mainButtonPadding = 8.0;
  final _itemButtonPadding = 8.0;

  RadialMenu(this.items,
      {this.childDistance = 80.0,
      this.iconRadius = 16.0,
      this.mainButtonRadius = 24.0,
      this.dialOpenDuration = 300,
      this.isClockwise = true,
      this.curve = Curves.easeInOutBack,
      this.area = Direction.circle});

  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List<Widget>();
    list.addAll(_buildChildren());
    list.add(_buildMainButton());
    return Container(
      width: widget.containersize,
      height: widget.containersize,
      // color: Colors.grey,
      child: Stack(
        alignment: Alignment.center,
        children: list,
      ),
    );
  }

  Widget _buildMainButton() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: widget.dialOpenDuration),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: opened
          ? InkWell(
              child: Padding(
                  padding: EdgeInsets.all(widget._mainButtonPadding),
                  child: Container(
                      height: widget.mainButtonRadius * 2,
                      width: widget.mainButtonRadius * 2,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget.mainButtonRadius),
                          color: Colors.red),
                      child: Center(
                          child: Icon(Icons.close, color: Colors.white)))),
              onTap: () {
                setState(() {
                  opened = false;
                });
              })
          : InkWell(
              child: Padding(
                  padding: EdgeInsets.all(widget._mainButtonPadding),
                  child: Container(
                      height: widget.mainButtonRadius * 2,
                      width: widget.mainButtonRadius * 2,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget.mainButtonRadius),
                          color: Colors.blue),
                      child: Center(
                          child: Icon(Icons.home, color: Colors.white)))),
              onTap: () {
                setState(() {
                  opened = true;
                });
              }),
    );
  }

  List<Widget> _buildChildren() {
    return widget.items.asMap().entries.map((e) {
      int index = e.key;
      RadialMenuItem item = e.value;
      final basePositionX = widget.containersize / 2 -
          (widget.iconRadius + widget._itemButtonPadding);
      final basePositionY = widget.containersize / 2 -
          (widget.iconRadius + widget._itemButtonPadding);
      return AnimatedPositioned(
          duration: Duration(milliseconds: widget.dialOpenDuration),
          curve: widget.curve,
          left: opened
              ? basePositionX +
                  widget.childDistance *
                      cos(_degreeToRadian(widget.angularWidth /
                              (widget.numDivide) *
                              index +
                          widget.startAngle))
              : basePositionX,
          top: opened
              ? basePositionY +
                  widget.childDistance *
                      sin(_degreeToRadian(widget.angularWidth /
                              (widget.numDivide) *
                              index +
                          widget.startAngle)) *
                      (widget.isClockwise ? 1 : -1)
              : basePositionY,
          child: _buildChild(item));
    }).toList();
  }

  Widget _buildChild(RadialMenuItem item) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: widget.dialOpenDuration),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(child: child, turns: animation);
        },
        child: InkWell(
          key: UniqueKey(),
          child: Padding(
              padding: EdgeInsets.all(widget._itemButtonPadding),
              child: Container(
                  height: widget.iconRadius * 2,
                  width: widget.iconRadius * 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.iconRadius),
                      color: item.color),
                  child: Center(child: item.child))),
          onTap: () {
            item.onSelected();
            setState(() {
              opened = false;
            });
          },
        ));
  }
}

double _degreeToRadian(double degree) {
  return degree * pi / 180;
}
