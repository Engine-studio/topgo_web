import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/functions/map_indexed.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/order_alert.dart';
import 'package:topgo_web/widgets/map/map.dart' as topgo;
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/widgets/order_details.dart';
import 'package:topgo_web/widgets/search.dart';

class AlertsTab extends StatefulWidget {
  const AlertsTab({Key? key}) : super(key: key);

  @override
  _AlertsTabState createState() => _AlertsTabState();
}

class _AlertsTabState extends State<AlertsTab> {
  int index = -1;
  LatLng? center;
  Widget? _widget;
  List<Order> _orders = [];

  @override
  void initState() {
    double _xSum = 0, _ySum = 0;
    int _count = 0;
    // TODO: implement initState
    super.initState();
    _orders = [1, 2, 3, 4, 5, 6, 7]
        .map(
          (i) => Order.shis(
            i * 151,
            i * 1000,
            i % 4 == 0
                ? OrderStatus.Cooking
                : i % 4 == 1
                    ? OrderStatus.Delivering
                    : i % 4 == 2
                        ? OrderStatus.Delivered
                        : OrderStatus.CourierFinding,
            'Константинов Абдурахмент Ибн Иль Амирович',
            "toAddr esstoAdd rasdasd" * i,
          ),
        )
        .toList();
    _orders.map((order) {
      if (order.toLatLng != null) {
        _count++;
        _xSum += order.toLatLng!.latitude;
        _ySum += order.toLatLng!.longitude;
      }
    });
    if (_count > 0) this.center = LatLng(_xSum / _count, _ySum / _count);
  }

  void pick(int index) {
    if (this.index != index)
      setState(() {
        this.index = index;
        _widget = OrderDetailsCard(order: _orders[index]);
      });
    else
      setState(() {
        this.index = -1;
        _widget = null;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: main.fullSize ? 30 : 24),
      child: Column(
        children: [
          SizedBox(height: 24),
          SearchLine(),
          SizedBox(height: 24),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    //flex: main.fullSize ? 610 : 350,
                    flex: 360,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Wrap(
                          runSpacing: 16,
                          children: _orders
                              .mapIndexed(
                                (index, order) => GestureDetector(
                                  onTap: () => pick(index),
                                  child: OrderAlert(
                                    order: order,
                                    picked: this.index == index,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    //flex: main.fullSize ? 641 : 378,
                    flex: 378,
                    child: Column(
                      children: [
                        if (_widget != null) _widget!,
                        if (_widget == null || main.fullSize) ...[
                          if (_widget != null) SizedBox(height: 16),
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              margin: EdgeInsets.only(bottom: 12),
                              child: topgo.Map(),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
