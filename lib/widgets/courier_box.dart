import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/widgets/border_box.dart';

class CourierBox extends StatelessWidget {
  final int orderStatus;
  final int orderId;
  final String orderAddress;
  final double orderPrice;

  final String courierName;

  const CourierBox(
      {Key? key,
      this.orderId = 123456,
      this.orderPrice = 99999,
      this.orderStatus = 0,
      this.courierName = "Константинов Константин Константинович",
      this.orderAddress =
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.dolor do amet sint. Velit officia consequat duis enim"})
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
        height: 136,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(getIconByStatus(orderStatus)),
                  Spacer(flex: 10),
                  Text('Номер заказа №$orderId'),
                  Spacer(flex: 137),
                  Text('$orderPrice руб'),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Курьер:'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Text('$courierName'),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '$orderAddress',
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
