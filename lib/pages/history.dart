import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/widgets/map/map_marker.dart';
import 'package:topgo_web/functions/map_indexed.dart';
import 'package:topgo_web/widgets/order_alert.dart';
import 'package:topgo_web/widgets/map/map.dart' as topgo;
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/widgets/order_details.dart';
import 'package:topgo_web/widgets/search.dart';
import 'package:provider/provider.dart';

class OrdersHistoryTab extends StatefulWidget {
  const OrdersHistoryTab({Key? key}) : super(key: key);

  @override
  _OrdersHistoryTabState createState() => _OrdersHistoryTabState();
}

class _OrdersHistoryTabState extends State<OrdersHistoryTab> {
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
    _orders = context.watch<Restaurant>().shownOrdersHistory;
    if (_orders.length == 0) _widget = null;
    if (center == null) setCenter();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: main.fullSize ? 30 : 24),
      child: Column(
        children: [
          SizedBox(height: 24),
          SearchLine(history: true),
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
                      // child: ListView.separated(
                      //   reverse: true,
                      //   itemCount: _orders.length,
                      //   itemBuilder: (context, index) => GestureDetector(
                      //     onTap: () => pick(index),
                      //     child: OrderAlert(
                      //       order: _orders[index],
                      //       picked: this.index == index,
                      //     ),
                      //   ),
                      //   separatorBuilder: (_, __) => SizedBox(height: 16),
                      // ),
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
                                center: center,
                                markers: [
                                  MapMarker.restaurant(self),
                                  if (index != -1 && _orders.length != 0)
                                    MapMarker.client(
                                      _orders[index].id,
                                      _orders[index].toLatLng!.latitude,
                                      _orders[index].toLatLng!.longitude,
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
