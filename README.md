# fl_radial_menu

Radial Menu Widget
![screeh capture](screenshot/screen.gif)

## install
```
dependencies:
  fl_radial_menu: ^0.0.1
```


## Example

```
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RadialMenu(items),
    );
  }
}
```