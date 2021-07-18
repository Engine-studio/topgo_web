import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/pages/alerts.dart';
import 'package:topgo_web/pages/delivery.dart';
import 'package:topgo_web/pages/history.dart';
import 'package:topgo_web/pages/profile.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/appbar.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:topgo_web/widgets/future_builder.dart';

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
  int _index = 2;
  bool needData = true;

  void switchOn(int index) => {
        if (index == 0)
          js.context.callMethod('open', ['https://topgo.club', '_self']),
        if (_index == 5)
          {
            //TODO: impl unlogin
            js.context.callMethod('open', ['https://topgo.club', '_self']),
          },
        setState(() {
          this.needData = true;
          this._index = index;
        })
      };

  Widget currentTab() {
    if (_index == 0 && _index == 5) return Container();
    if (!needData) {
      return _index == 1
          ? DeliveryTab()
          : _index == 2
              ? AlertsTab()
              : _index == 3
                  ? ProfileTab()
                  : OrdersHistoryTab();
    } else {
      needData = false;
      return TopGoFutureBuilder(
        child: _index == 1
            ? DeliveryTab()
            : _index == 2
                ? AlertsTab()
                : _index == 3
                    ? ProfileTab()
                    : OrdersHistoryTab(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TopGo',
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight < 650)
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
              child: currentTab(),
            ),
          );
        },
      ),
    );
  }
}
