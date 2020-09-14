import 'dart:math';

import 'package:flutter/material.dart';
import 'radial_menu_item.dart';

enum Fanout {
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
  final double itemButtonRadius;
  final double mainButtonRadius;
  final bool isClockwise;
  final int dialOpenDuration;
  final Curve curve;
  final Fanout fanout;
  final Icon closedIcon;

  final _mainButtonPadding = 8.0;
  final _itemButtonPadding = 8.0;

  Size get containersize {
    double overshootBuffer = 10;

    switch (fanout) {
      case Fanout.topLeft:
      case Fanout.topRight:
      case Fanout.bottomLeft:
      case Fanout.bottomRight:
        double w =
            childDistance + itemButtonRadius + mainButtonRadius + overshootBuffer;
        double h = w;
        return Size(w, h);
        break;
      case Fanout.top:
      case Fanout.bottom:
        double w = (childDistance + itemButtonRadius) * 2 + overshootBuffer;
        double h = childDistance +
            itemButtonRadius +
            mainButtonRadius +
            _mainButtonPadding +
            overshootBuffer;
        return Size(w, h);
        break;
      case Fanout.left:
      case Fanout.right:
        double w = childDistance +
            itemButtonRadius +
            mainButtonRadius +
            _mainButtonPadding +
            overshootBuffer;
        double h = (childDistance + itemButtonRadius) * 2 + overshootBuffer;
        return Size(w, h);
        break;
      case Fanout.circle:
        double w = (childDistance + itemButtonRadius) * 2 + overshootBuffer;
        double h = w;
        return Size(w, h);
        break;
    }
    return Size(0, 0);
  }

  Alignment get stackAlignment {
    switch (fanout) {
      case Fanout.topLeft:
        return Alignment.bottomRight;
        break;
      case Fanout.topRight:
        return Alignment.bottomLeft;
        break;
      case Fanout.bottomLeft:
        return Alignment.topRight;
        break;
      case Fanout.bottomRight:
        return Alignment.topLeft;
        break;
      case Fanout.top:
        return Alignment.bottomCenter;
        break;
      case Fanout.bottom:
        return Alignment.topCenter;
        break;
      case Fanout.left:
        return Alignment.centerRight;
        break;
      case Fanout.right:
        return Alignment.centerLeft;
        break;
      case Fanout.circle:
      default:
        return Alignment.center;
        break;
    }
  }

  int get startAngle {
    switch (fanout) {
      case Fanout.topLeft:
        return isClockwise ? 180 : 90;
        break;
      case Fanout.topRight:
        return isClockwise ? 270 : 0;
        break;
      case Fanout.bottomLeft:
        return isClockwise ? 90 : 180;
        break;
      case Fanout.bottomRight:
        return isClockwise ? 0 : 270;
        break;
      case Fanout.top:
        return isClockwise ? 180 : 0;
        break;
      case Fanout.bottom:
        return isClockwise ? 0 : 180;
        break;
      case Fanout.left:
        return 90;
        break;
      case Fanout.right:
        return 270;
        break;
      case Fanout.circle:
      default:
        return 0;
        break;
    }
  }

  int get angularWidth {
    switch (fanout) {
      case Fanout.topLeft:
      case Fanout.topRight:
      case Fanout.bottomLeft:
      case Fanout.bottomRight:
        return 90;
        break;
      case Fanout.top:
      case Fanout.bottom:
      case Fanout.left:
      case Fanout.right:
        return 180;
        break;
      case Fanout.circle:
      default:
        return 360;
        break;
    }
  }

  int get numDivide {
    if (angularWidth == 360.0) {
      return items.length;
    } else {
      return items.length - 1;
    }
  }

  double animationRelativePosX(int index) {
    return childDistance *
        cos(_degreeToRadian(angularWidth / (numDivide) * index + startAngle));
  }

  double animationRelativePosY(int index) {
    return childDistance *
        sin(_degreeToRadian(angularWidth / (numDivide) * index + startAngle)) *
        (isClockwise ? 1 : -1);
  }

  Offset get posDelta {
    final x = (mainButtonRadius + _mainButtonPadding) -
        (itemButtonRadius + _itemButtonPadding);
    final y = (mainButtonRadius + _mainButtonPadding) -
        (itemButtonRadius + _itemButtonPadding);
    return Offset(x, y);
  }

  RadialMenu(this.items,
      {this.childDistance = 90.0,
      this.itemButtonRadius = 16.0,
      this.mainButtonRadius = 24.0,
      this.dialOpenDuration = 300,
      this.isClockwise = true,
      this.curve = Curves.easeInOutBack,
      this.fanout = Fanout.circle,
      this.closedIcon = Icon(Icons.home, color: Colors.white)});

  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu> {
  bool opened = false;

  final GlobalKey _key = GlobalKey();
  Size _size = Size(0.0, 0.0);

  getSizeAndPosition() {
    RenderBox _renderBox = _key.currentContext.findRenderObject();
    setState(() {
      _size = _renderBox.size;      
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List<Widget>();
    list.addAll(_buildChildren());
    list.add(_buildMainButton());

    return Container(
      key: _key,
      width: widget.containersize.width,
      height: widget.containersize.height,
      //for debug
      // color: Colors.grey,
      child: Stack(
        alignment: widget.stackAlignment,
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
                          child: closedIcon))),
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

      return AnimatedPositioned(
          duration: Duration(milliseconds: widget.dialOpenDuration),
          curve: widget.curve,
          left: opened
              ? position.dx + widget.animationRelativePosX(index)
              : position.dx,
          top: opened
              ? position.dy + widget.animationRelativePosY(index)
              : position.dy,
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
                  height: widget.itemButtonRadius * 2,
                  width: widget.itemButtonRadius * 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.itemButtonRadius),
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

  Offset get position {
    return axisOrigin + widget.posDelta;
  }

  Offset get axisOrigin {
    switch (widget.fanout) {
      case Fanout.topLeft:
        final x = _size.width - (widget.mainButtonRadius + widget._mainButtonPadding) * 2;
        final y = _size.height - (widget.mainButtonRadius + widget._mainButtonPadding) * 2;
        return Offset(x, y);
        break;
      case Fanout.topRight:
        final x = 0.0;
        final y = _size.height - (widget.mainButtonRadius + widget._mainButtonPadding) * 2;
        return Offset(x, y);
        break;
      case Fanout.bottomLeft:
        final x = _size.width  - (widget.mainButtonRadius + widget._mainButtonPadding) * 2;
        final y = 0.0;
        return Offset(x, y);
        break;
      case Fanout.bottomRight:
        final x = 0.0;
        final y = 0.0;
        return Offset(x, y);
        break;
      case Fanout.top:
        final x = _size.width / 2- (widget.mainButtonRadius + widget._mainButtonPadding);
        final y = _size.height - (widget.mainButtonRadius + widget._mainButtonPadding)* 2;
        return Offset(x, y);
        break;
      case Fanout.bottom:
        final x = _size.width / 2- (widget.mainButtonRadius + widget._mainButtonPadding);
        final y = 0.0;
        return Offset(x, y);
        break;
      case Fanout.left:
        final x = _size.width - (widget.mainButtonRadius + widget._mainButtonPadding) * 2;
        final y = _size.height / 2 - (widget.mainButtonRadius + widget._mainButtonPadding);
        return Offset(x, y);
        break;
      case Fanout.right:
        final x = 0.0;
        final y = _size.height / 2 - (widget.mainButtonRadius + widget._mainButtonPadding);
        return Offset(x, y);
        break;
      case Fanout.circle:
      default:
      print(_size);
        final x = _size.width / 2 - (widget.mainButtonRadius + widget._mainButtonPadding);
        final y = _size.height / 2 - (widget.mainButtonRadius + widget._mainButtonPadding);
        return Offset(x, y);
        break;
    }
  }
}

double _degreeToRadian(double degree) {
  return degree * pi / 180;
}
