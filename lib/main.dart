import 'dart:async';

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
      MaterialApp(
        title: 'TopGo',
        debugShowCheckedModeBanner: false,
        home: ChangeNotifierProvider<Restaurant>(
          create: (_) => Restaurant(),
          child: LoginPage(),
        ),
      ),
    );

class WebApp extends StatefulWidget {
  @override
  _WebAppState createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  Timer? timer;
  BuildContext? thisContext;

  int _index = 3;
  bool needData = true;

  void switchOn(int index, BuildContext context) => {
        if (index == 0)
          js.context.callMethod('open', ['https://topgo.club', '_self']),
        if (index == 5)
          {
            context.read<Restaurant>().unlogin(),
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ChangeNotifierProvider<Restaurant>(
                    create: (_) => Restaurant(),
                    child: LoginPage(),
                  );
                },
              ),
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
          ? DeliveryTab(redirect: () => switchOn(2, context))
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
            ? DeliveryTab(redirect: () => switchOn(2, context))
            : _index == 2
                ? AlertsTab()
                : _index == 3
                    ? ProfileTab()
                    : OrdersHistoryTab(),
      );
    }
  }

  void polling() async {
    print('POLLING');
    try {
      await getAlerts(thisContext!);
    } catch (e) {
      print('POLLING ERR: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    thisContext = context;

    if (timer == null)
      timer = Timer.periodic(
        Duration(seconds: 30),
        (t) => {if (thisContext != null) polling()},
      );

    return LayoutBuilder(
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

  Future<void> submit(BuildContext context) async {
    String number = phone.text;
    for (String str in ['+', '(', ')', '-', ' '])
      number = number.replaceAll(str, '');
    number = "09123323232";
    password.text = 'admin';
    if (number.length == 11 && password.text != '') {
      context.read<Restaurant>().setLoginData(number, password.text);
      if (await logIn(context))
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ChangeNotifierProvider.value(
                value: Provider.of<Restaurant>(context, listen: false),
                child: WebApp(),
              );
            },
          ),
        );
      else
        password.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight < 650)
          return Center(
            child: Text('Screen is too small', style: TxtStyle.H1),
          );
        if (constraints.maxWidth < 768)
          return Center(
            child: Text('Screen is too small', style: TxtStyle.H1),
          );
        return Scaffold(
          body: Container(
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
                SizedBox(
                  width: 275,
                  child: Input(
                    text: 'Логин',
                    controller: phone,
                    onSubmit: () async => {await submit(context)},
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: 275,
                  child: Input(
                    text: 'Пароль',
                    controller: password,
                    onSubmit: () async => {await submit(context)},
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 275,
                  child: Button(
                    text: 'Вход',
                    buttonType: ButtonType.Select,
                    onPressed: () async => {await submit(context)},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
