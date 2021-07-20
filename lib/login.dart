import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:topgo_web/api.dart';
import 'package:topgo_web/main.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/input.dart';

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
    return Container(
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
                context.read<Restaurant>().setLoginData(number, password.text);
                bool result = await logIn(context);
                if (result)
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WebApp()));
              }
            },
          ),
        ],
      ),
    );
  }
}
