import 'package:flutter/material.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/appbar.dart';

late bool fullSize;

void main() {
  runApp(WebApp());
}

class WebApp extends StatefulWidget {
  @override
  _WebAppState createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  int _index = 0;

  final tabs = [
    Center(child: Tab(icon: Icon(Icons.arrow_upward))),
    Center(child: Tab(icon: Icon(Icons.arrow_forward))),
    Center(child: Tab(icon: Icon(Icons.arrow_downward))),
    Center(child: Tab(icon: Icon(Icons.arrow_back))),
  ];

  void switchOn(int index) => setState(() {
        this._index = index;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TopGo',
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 768)
            return Center(
              child: Text('Screen is too small', style: TxtStyle.H1),
            );
          fullSize =
              !(constraints.maxWidth >= 768 && constraints.maxWidth < 1200);
          return Scaffold(
            appBar: Appbar(
              onTap: switchOn,
            ),
            body: SafeArea(
              child: tabs[_index],
            ),
          );
        },
      ),
    );
  }
}
