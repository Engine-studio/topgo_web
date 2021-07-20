import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topgo_web/api.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/pages/alerts.dart';
import 'package:topgo_web/pages/delivery.dart';
import 'package:topgo_web/pages/history.dart';
import 'package:topgo_web/pages/profile.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/appbar.dart';
import 'package:topgo_web/widgets/button.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:topgo_web/widgets/future_builder.dart';
import 'package:topgo_web/widgets/input.dart';

late bool fullSize;

void main() => runApp(
      ChangeNotifierProvider<Restaurant>(
        create: (context) => Restaurant(),
        child: LoginPage(),
      ),
    );

class WebApp extends StatefulWidget {
  @override
  _WebAppState createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  int _index = 2;
  bool needData = true;

  void switchOn(int index, BuildContext context) => {
        if (index == 0)
          js.context.callMethod('open', ['https://topgo.club', '_self']),
        if (index == 5)
          {
            context.read<Restaurant>().unlogin(),
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            ),
          }
        else
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
        future: _index == 4 ? getOrdersHistory : null,
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
    return Scaffold(
      appBar: Appbar(
        onTap: switchOn,
      ),
      body: SafeArea(
        child: currentTab(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late MaskedTextController phone;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    phone = MaskedTextController(mask: '+0 (000) 000-00-00');
    password = TextEditingController();
  }

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String number;
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
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 200),
              width: double.infinity,
              decoration: BoxDecoration(gradient: GrdStyle.panel),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 50,
                  ),
                  SizedBox(height: 40),
                  Input(text: 'Логин', controller: phone),
                  SizedBox(height: 24),
                  Input(text: 'Пароль', controller: password),
                  SizedBox(height: 40),
                  Button(
                    text: 'Вход',
                    buttonType: ButtonType.Select,
                    onPressed: () async {
                      number = phone.text;
                      for (String str in ['+', '(', ')', '-', ' '])
                        number = number.replaceAll(str, '');
                      if (number.length == 11 && password.text != '') {
                        context
                            .read<Restaurant>()
                            .setLoginData(number, password.text);
                        if (await logIn(context))
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => WebApp()),
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
