import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/functions/money_string.dart';
import 'package:topgo_web/functions/phone_string.dart';
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/border_box.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/grading_dialog.dart';
import 'package:topgo_web/widgets/item_holder.dart';
import 'package:topgo_web/widgets/order_state_line.dart';
import 'package:provider/provider.dart';

class OrderDetailsCard extends StatefulWidget {
  final Order order;
  final void Function() removeSelf;
  const OrderDetailsCard({
    Key? key,
    required this.order,
    required this.removeSelf,
  }) : super(key: key);

  @override
  _OrderDetailsCardState createState() => _OrderDetailsCardState();
}

class _OrderDetailsCardState extends State<OrderDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return BorderBox(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.order.courierName ?? 'No data',
              style: TxtStyle.H2,
            ),
            SizedBox(height: 8),
            OrderStateLine(
                status: widget.order.status ?? OrderStatus.CourierFinding),
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
                    '${widget.order.id ?? "No data"}',
                    style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                ItemHolder(
                  header: 'Сумма заказа:',
                  style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                  horizontal: false,
                  item: Text(
                    moneyString(widget.order.sum ?? 0),
                    style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                ItemHolder(
                  header: 'Вид оплаты:',
                  style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                  horizontal: false,
                  item: Text(
                    widget.order.paymentType == OrderPayment.Cash
                        ? 'Наличные'
                        : widget.order.paymentType == OrderPayment.Terminal
                            ? 'Терминал'
                            : 'Оплачен',
                    style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                ItemHolder(
                  header: 'Номер курьера:',
                  style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                  horizontal: false,
                  item: Text(
                    phoneString(widget.order.courierPhone ?? '00000000000'),
                    style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                ItemHolder(
                  header: 'Номер клиента:',
                  style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                  horizontal: false,
                  item: Text(
                    phoneString(widget.order.clientPhone!),
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
                widget.order.toAddress ?? 'No data',
                style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
              ),
            ),
            SizedBox(height: 16),
            ItemHolder(
              header: 'Состав заказа:',
              style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
              item: Text(
                widget.order.body ?? 'No data',
                style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
              ),
            ),
            SizedBox(height: 16),
            ItemHolder(
              header: 'Комментарий:',
              width: 110,
              style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
              item: Text(
                widget.order.comment ?? 'No data',
                style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ...widget.order.status == OrderStatus.CourierFinding ||
                          widget.order.status == OrderStatus.CourierConfirmation
                      ? []
                      : [],
                  if (widget.order.status == OrderStatus.Cooking)
                    SizedBox(
                      width: 155,
                      child: Button(
                        text: 'Заказ готов',
                        buttonType: ButtonType.Accept,
                        onPressed: () async => await context
                            .read<Restaurant>()
                            .orderReady(context, widget.order),
                      ),
                    ),
                  if (widget.order.status == OrderStatus.Delivered &&
                      widget.order.rate == 0)
                    Container(
                      width: 155,
                      child: Button(
                        text: 'Оценить заказ',
                        buttonType: ButtonType.Select,
                        onPressed: () async => showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return ChangeNotifierProvider.value(
                              value: Provider.of<Restaurant>(context,
                                  listen: false),
                              child: GradingDialog(
                                rate: (context, list) async {
                                  await context
                                      .read<Restaurant>()
                                      .orderRate(context, widget.order, list);
                                  setState(() => {});
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  if (widget.order.status != OrderStatus.Delivered &&
                      widget.order.status != OrderStatus.Success)
                    Container(
                      margin: const EdgeInsets.only(left: 24),
                      width: 155,
                      child: Button(
                        text: 'Отменить заказ',
                        buttonType: ButtonType.Decline,
                        onPressed: () async => {
                          await context
                              .read<Restaurant>()
                              .orderCancel(context, widget.order),
                          widget.removeSelf(),
                        },
                      ),
                    ),
                  if (widget.order.status == OrderStatus.Success)
                    Container(
                      margin: const EdgeInsets.only(left: 24),
                      alignment: Alignment.centerRight,
                      height: 44,
                      width: 155,
                      child: Row(
                        children: [
                          Text(
                            widget.order.rate.toString(),
                            style: TxtStyle.H3,
                          ),
                          SizedBox(width: 10),
                          Image.asset("assets/icons/star.png", height: 19),
                        ],
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
