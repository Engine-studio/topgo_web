import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/functions/money_string.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/dialog.dart';
import 'package:topgo_web/widgets/item_holder.dart';

class CreateDialog extends StatelessWidget {
  final Order order;
  const CreateDialog({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      width: 415,
      height: 124,
      closeButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 22),
            ItemHolder(
              header: 'Стоимость доставки',
              width: 189,
              item: Text(
                order.deliverySum != -1
                    ? '${moneyString(order.deliverySum!, rub: false)} руб.'
                    : 'Not found',
                style: TxtStyle.H3,
              ),
            ),
            Spacer(),
            Button(
              text: 'Создать заказ',
              buttonType: ButtonType.Accept,
              onPressed: () async => {
                if (order.deliverySum != -1)
                  {
                    //TODO: impl sending,

                    Navigator.pop(context),
                  }
              },
            ),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
