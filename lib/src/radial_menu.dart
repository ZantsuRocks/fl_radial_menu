import 'dart:math';

import 'package:flutter/material.dart';
import 'radial_menu_item.dart';

class RadialMenu extends StatefulWidget {
  final List<RadialMenuItem> items;
  final childDistance;
  final iconRadius;
  final mainButtonRadius;
  final startAngle;
  final angularWidth;
  final isClockwise;
  final dialOpenDuration;
  final curve;

  final _buttonPadding = 8.0;

  RadialMenu(this.items,
      {this.childDistance = 80,
      this.iconRadius = 16.0,
      this.mainButtonRadius = 24.0,
      this.dialOpenDuration = 300,
      this.startAngle = 0,
      this.angularWidth = 90,
      this.isClockwise = true,
      this.curve = Curves.easeInOutBack});

  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List<Widget>() + _buildChildren() + [_buildMainButton()],
    );
  }

  Widget _buildMainButton() {
    return Align(
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: widget.dialOpenDuration),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: opened
            ? InkWell(
                child: Padding(
                    padding: EdgeInsets.all(widget._buttonPadding),
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
                    padding: EdgeInsets.all(widget._buttonPadding),
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
      ),
    );
  }

  List<Widget> _buildChildren() {
    return widget.items.asMap().entries.map((e) {
      int index = e.key;
      RadialMenuItem item = e.value;

      final basePositionX =
          MediaQuery.of(context).size.width / 2 - (widget.iconRadius + widget._buttonPadding);
      final basePositionY =
          MediaQuery.of(context).size.height / 2 - (widget.iconRadius + widget._buttonPadding);
      return AnimatedPositioned(
          duration: Duration(milliseconds: widget.dialOpenDuration),
          curve: widget.curve,
          left: opened
              ? basePositionX +
                  widget.childDistance *
                      cos(_degreeToRadian(widget.angularWidth /
                              (widget.items.length - 1) *
                              index +
                          widget.startAngle)) *
                      (widget.isClockwise ? -1 : 1)
              : basePositionX,
          top: opened
              ? basePositionY +
                  widget.childDistance *
                      sin(_degreeToRadian(widget.angularWidth /
                              (widget.items.length - 1) *
                              index +
                          widget.startAngle)) *
                      (widget.isClockwise ? -1 : 1)
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
              padding: EdgeInsets.all(widget._buttonPadding),
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
