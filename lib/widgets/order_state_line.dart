import 'package:flutter/widgets.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/functions/map_indexed.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/main.dart' as main;

class OrderStateLine extends StatelessWidget {
  final OrderStatus? status;
  const OrderStateLine({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index;
    if (status == OrderStatus.CourierFinding ||
        status == OrderStatus.CourierConfirmation)
      index = 0;
    else if (status == OrderStatus.Cooking ||
        status == OrderStatus.ReadyForDelivery)
      index = 2;
    else if (status == OrderStatus.Delivering)
      index = 4;
    else if (status == OrderStatus.Delivered)
      index = 6;
    else
      index = -1;
    return SizedBox(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          'Поиск\nкурьера',
          '',
          'Приготовление\nзаказа',
          '',
          'Доставка\nзаказа',
          '',
          'Заказ\nдоставлен',
        ]
            .mapIndexed(
              (ind, str) => ind < index
                  ? ind % 2 == 0
                      ? Text(
                          str,
                          style: TxtStyle.H4
                              .copyWith(fontSize: main.fullSize ? 14 : 10),
                          textAlign: TextAlign.center,
                        )
                      : Container(color: ClrStyle.icons, width: 18, height: 1.5)
                  : ind == index
                      ? Text(
                          str,
                          style: TxtStyle.H4
                              .copyWith(color: ClrStyle.lightSelect)
                              .copyWith(fontSize: main.fullSize ? 14 : 10),
                          textAlign: TextAlign.center,
                        )
                      : ind % 2 == 0
                          ? Text(
                              str,
                              style: TxtStyle.H4
                                  .copyWith(
                                      color: ClrStyle.text.withOpacity(0.5))
                                  .copyWith(fontSize: main.fullSize ? 14 : 10),
                              textAlign: TextAlign.center,
                            )
                          : Container(
                              color: ClrStyle.icons.withOpacity(0.5),
                              width: 18,
                              height: 1.5,
                            ),
            )
            .toList(),
      ),
    );
  }
}
