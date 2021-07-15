import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/functions/money_string.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/border_box.dart';
import 'package:topgo_web/widgets/item_holder.dart';

class OrderAlert extends StatelessWidget {
  final Order order;
  final bool picked;

  const OrderAlert({Key? key, required this.order, this.picked = false})
      : super(key: key);

  IconData getIconByStatus(int status) {
    switch (status) {
      case 0:
        return Icons.star;
      case 1:
        return Icons.done;
      case 2:
        return Icons.not_interested;
      case 3:
        return Icons.zoom_in;
      default:
        return Icons.alarm;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BorderBox(
        height: 139,
        child: Container(
          decoration: BoxDecoration(
            gradient: picked
                ? GrdStyle.lightPanel
                : LinearGradient(colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFFFFFFF),
                  ]),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 20,
                child: Row(
                  children: [
                    Icon(getIconByStatus(order.id! % 4)),
                    Spacer(flex: 10),
                    Text('Номер заказа №${order.id}', style: TxtStyle.H2),
                    Spacer(flex: 137),
                    Text(moneyString(order.sum ?? 0), style: TxtStyle.H2),
                  ],
                ),
              ),
              ItemHolder(
                header: 'Курьер:',
                style: TxtStyle.H4,
                item: Text(
                  order.courierName ?? 'No data',
                  style: TxtStyle.H5,
                ),
              ),
              ItemHolder(
                header: 'Адрес:',
                style: TxtStyle.H4,
                item: Text(
                  order.toAddress ?? 'No data',
                  style: TxtStyle.H5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
