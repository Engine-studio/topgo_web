import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/pages/profile.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/appbar.dart';

late bool fullSize;

void main() => runApp(
      ChangeNotifierProvider<Restaurant>(
        create: (context) => Restaurant(),
        child: WebApp(),
      ),
    );

class WebApp extends StatefulWidget {
  @override
  _WebAppState createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  int _index = 0;

  final tabs = [
    ProfileTab(),
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
          if (constraints.maxHeight < 550)
            return Center(
              child: Text('Screen is too small', style: TxtStyle.H1),
            );
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
