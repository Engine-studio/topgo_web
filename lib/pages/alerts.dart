import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/widgets/map/map_marker.dart';
import 'package:topgo_web/widgets/order_alert.dart';
import 'package:topgo_web/widgets/map/map.dart' as topgo;
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/widgets/order_details.dart';
import 'package:topgo_web/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:topgo_web/functions/map_indexed.dart';

class AlertsTab extends StatefulWidget {
  const AlertsTab({Key? key}) : super(key: key);

  @override
  _AlertsTabState createState() => _AlertsTabState();
}

class _AlertsTabState extends State<AlertsTab> {
  int index = -1;
  int? id;
  LatLng? center;
  Widget? _widget;
  List<Order> _orders = [];

  void setCenter() {
    double _xSum = 0, _ySum = 0;
    int _count = 0;
    _orders.map((order) {
      if (order.toLatLng != null) {
        _count++;
        _xSum += order.toLatLng!.latitude;
        _ySum += order.toLatLng!.longitude;
      }
    });
    if (_count > 0)
      setState(
        () => this.center = LatLng(_xSum / _count, _ySum / _count),
      );
  }

  void pick(int index) {
    if (this.index != index)
      setState(() {
        this.index = index;
        this.id = _orders[index].id!;
        _widget = OrderDetailsCard(
            order: _orders[index],
            removeSelf: () => setState(() => {_widget = null}));
      });
    else
      setState(() {
        this.index = -1;
        _widget = null;
      });
  }

  void pickById(int id) {
    int ind = -1;
    for (int i = 0; i < _orders.length; i++) if (_orders[i].id == id) ind = i;
    setState(() {
      this.index = ind;
      this.id = id;
      _widget = OrderDetailsCard(
          order: _orders[ind],
          removeSelf: () => setState(() => {_widget = null}));
    });
  }

  @override
  Widget build(BuildContext context) {
    Restaurant self = context.read<Restaurant>();
    _orders = context.watch<Restaurant>().shownOrders.reversed.toList();
    if (center == null) setCenter();
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
                    flex: main.fullSize ? 610 : 350,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            children: _orders.reversed
                                .toList()
                                .mapIndexed(
                                  (index, order) => Container(
                                    margin: EdgeInsets.only(
                                      bottom:
                                          index == _orders.length - 1 ? 0 : 16,
                                    ),
                                    child: GestureDetector(
                                      onTap: () => pick(index),
                                      child: OrderAlert(
                                        order: _orders[index],
                                        picked: this.index == index,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: main.fullSize ? 641 : 378,
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
                              child: topgo.Map(
                                id: id,
                                center: center,
                                onTap: pickById,
                                markers: [
                                  MapMarker.restaurant(self),
                                  for (Order order in _orders)
                                    if (order.status != OrderStatus.Delivered &&
                                        order.status != OrderStatus.Success)
                                      MapMarker.client(
                                        order.id,
                                        order.toLatLng!.latitude,
                                        order.toLatLng!.longitude,
                                      ),
                                  for (Order order in _orders)
                                    if (order.status != OrderStatus.Delivered &&
                                        order.status != OrderStatus.Success &&
                                        order.status !=
                                            OrderStatus.CourierFinding &&
                                        order.status !=
                                            OrderStatus.CourierConfirmation)
                                      MapMarker.courier(
                                        order.id,
                                        order.courierLatLng!.latitude,
                                        order.courierLatLng!.longitude,
                                      ),
                                ],
                              ),
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
