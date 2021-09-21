import 'package:flutter/material.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/dialog.dart';

class CreationSuccessDialog extends StatelessWidget {
  final Function() redirect;
  const CreationSuccessDialog({Key? key, required this.redirect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      width: 412,
      height: 175,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            SizedBox(
              width: 412,
              child: Text(
                'Заказ успешно оформлен',
                style: TxtStyle.H1,
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Text(
              'Вы успешно создали заказ,\nначинается поиск курьера.',
              style: TxtStyle.H5,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            SizedBox(
              width: 182,
              child: Button(
                text: 'Продолжить',
                buttonType: ButtonType.Accept,
                onPressed: () async => {
                  Navigator.pop(context),
                  redirect(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
