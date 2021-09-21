import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/functions/money_string.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/border_box.dart';
import 'package:topgo_web/widgets/item_holder.dart';
import 'package:topgo_web/main.dart' as main;

class OrderAlert extends StatelessWidget {
  final Order order;
  final bool picked;

  OrderAlert({Key? key, required this.order, this.picked = false})
      : super(key: key);

  String assetNameForStatus(OrderStatus? status) {
    String _path = 'assets/icons/';
    if (status == OrderStatus.CourierFinding ||
        status == OrderStatus.CourierConfirmation)
      _path += 'search';
    else if (status == OrderStatus.Cooking)
      _path += 'history-alt';
    else if (status == OrderStatus.Delivering ||
        status == OrderStatus.ReadyForDelivery)
      _path += 'car';
    else if (status == OrderStatus.Delivered)
      _path += 'star';
    else if (status == OrderStatus.FailureByCourier ||
        status == OrderStatus.FailureByRestaurant)
      _path += 'cancel';
    else if (status == OrderStatus.Success)
      _path += 'comment-verify';
    else
      _path += 'x';
    return _path + '.png';
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
                    Image.asset(assetNameForStatus(order.status), height: 20),
                    Spacer(flex: 10),
                    Text(
                      'Номер заказа №${order.id}',
                      style: main.fullSize ? TxtStyle.H2 : TxtStyle.h2,
                    ),
                    Spacer(flex: 137),
                    Text(
                      moneyString(order.sum ?? 0),
                      style: main.fullSize ? TxtStyle.H2 : TxtStyle.h2,
                    ),
                  ],
                ),
              ),
              ItemHolder(
                header: 'Курьер:',
                style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                item: Text(
                  order.courierName ?? 'No data',
                  style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                ),
              ),
              ItemHolder(
                header: 'Адрес:',
                style: main.fullSize ? TxtStyle.H4 : TxtStyle.h3,
                item: Text(
                  order.toAddress ?? 'No data',
                  style: main.fullSize ? TxtStyle.H5 : TxtStyle.h4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
