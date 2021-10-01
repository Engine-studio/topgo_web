import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/functions/money_string.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/creation_success_dialog.dart';
import 'package:topgo_web/widgets/dialog.dart';
import 'package:topgo_web/widgets/item_holder.dart';

class CreateDialog extends StatelessWidget {
  final Order order;
  final Function() redirect;
  final Future<bool> Function(Order) confirm;
  const CreateDialog({
    Key? key,
    required this.order,
    required this.confirm,
    required this.redirect,
  }) : super(key: key);

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
                    : 'не определена',
                style: TxtStyle.H3,
              ),
            ),
            Spacer(),
            Button(
              text: order.deliverySum != -1
                  ? 'Создать заказ'
                  : 'Попробуйте снова',
              buttonType: order.deliverySum != -1
                  ? ButtonType.Accept
                  : ButtonType.Decline,
              onPressed: () async => {
                if (order.deliverySum != -1)
                  {
                    if (await confirm(order))
                      {
                        Navigator.pop(context),
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => CreationSuccessDialog(
                            redirect: redirect,
                          ),
                        ),
                      },
                  }
                else
                  {
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
