import 'package:flutter/widgets.dart';
import 'package:topgo_web/functions/money_string.dart';
import 'package:topgo_web/functions/phone_string.dart';
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/border_box.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/item_holder.dart';
import 'package:topgo_web/widgets/order_state_line.dart';
import 'package:provider/provider.dart';

class OrderDetailsCard extends StatelessWidget {
  final Order order;
  const OrderDetailsCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderBox(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              order.courierName!,
              style: TxtStyle.H2,
            ),
            SizedBox(height: 8),
            OrderStateLine(status: order.status),
            SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                ItemHolder(
                  header: 'Номер заказа:',
                  style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                  horizontal: false,
                  item: Text(
                    '${order.id!}',
                    style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                ItemHolder(
                  header: 'Сумма заказа:',
                  style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                  horizontal: false,
                  item: Text(
                    moneyString(order.sum ?? 0),
                    style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                ItemHolder(
                  header: 'Вид оплаты:',
                  style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                  horizontal: false,
                  item: Text(
                    order.withCash == true ? 'Наличные' : 'Терминал',
                    style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                ItemHolder(
                  header: 'Номер курьера:',
                  style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                  horizontal: false,
                  item: Text(
                    phoneString(order.courierPhone!),
                    style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                ItemHolder(
                  header: 'Номер клиента:',
                  style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                  horizontal: false,
                  item: Text(
                    phoneString(order.clientPhone!),
                    style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ItemHolder(
              header: 'Адрес:',
              style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
              item: Text(
                order.toAddress ?? 'No data',
                style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
              ),
            ),
            SizedBox(height: 16),
            ItemHolder(
              header: 'Состав заказа:',
              style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
              item: Text(
                order.body ?? 'No data',
                style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
              ),
            ),
            SizedBox(height: 16),
            ItemHolder(
              header: 'Комментарий:',
              width: 110,
              style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
              item: Text(
                order.comment ?? 'No data',
                style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ...order.status == OrderStatus.CourierFinding ||
                          order.status == OrderStatus.CourierConfirmation
                      ? []
                      : [],
                  if (order.status == OrderStatus.Cooking)
                    SizedBox(
                      width: 155,
                      child: Button(
                        text: 'Заказ готов',
                        buttonType: ButtonType.Accept,
                        onPressed: () async => context
                            .read<Restaurant>()
                            .orderReady(context, order),
                      ),
                    ),
                  if (order.status == OrderStatus.Delivered &&
                      order.appearance == null)
                    Container(
                      width: 155,
                      child: Button(
                        text: 'Оценить заказ',
                        buttonType: ButtonType.Select,
                        onPressed: () async => {},
                      ),
                    ),
                  if (order.status != OrderStatus.Delivered &&
                      order.status != OrderStatus.Success)
                    Container(
                      margin: const EdgeInsets.only(left: 24),
                      width: 155,
                      child: Button(
                        text: 'Отменить заказ',
                        buttonType: ButtonType.Decline,
                        onPressed: () async => {},
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
