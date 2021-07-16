import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/functions/money_string.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/widgets/search.dart';

class Restaurant with ChangeNotifier {
  int? id;
  double? x, y;
  String? name, address, phone, password;
  List<int>? open, close;

  late List<Order> orders, shownOrders;

  Restaurant()
      : id = 0,
        x = 55.75222,
        y = 37.61556,
        name = 'RestautantNumberOne',
        address =
            'Pushkin street, Kukushkin house AND Pushkin street, Kukushkin house',
        phone = '78005553535',
        password = '123',
        open = [10, 0],
        close = [20, 0] {
    orders = [1, 2, 3, 4, 5, 6, 7]
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
    shownOrders = orders;
  }

  void formShown({required String text, required SearchType type}) {
    shownOrders = type == SearchType.All
        ? orders
        : type == SearchType.Cooking
            ? List.from(orders.where((order) => [
                  OrderStatus.Cooking,
                  OrderStatus.ReadyForDelivery
                ].contains(order.status)))
            : type == SearchType.Delivering
                ? List.from(orders.where((order) => [
                      OrderStatus.Delivering,
                    ].contains(order.status)))
                : type == SearchType.Done
                    ? List.from(orders.where((order) => [
                          OrderStatus.Success,
                          OrderStatus.Delivered,
                        ].contains(order.status)))
                    : List.from(orders.where((order) => [
                          OrderStatus.CourierFinding,
                          OrderStatus.CourierConfirmation,
                        ].contains(order.status)));

    shownOrders = List.from(
      shownOrders.where(
        (order) =>
            order.courierName!.contains(text) ||
            order.id!.toString().contains(text) ||
            order.toAddress!.contains(text) ||
            order.sum!.toString().contains(text) ||
            moneyString(order.sum!).contains(text),
      ),
    );

    formatShown();
  }

  void formatShown() {
    List<Order> tmp = [];
    tmp.addAll(shownOrders.where((order) => [
          OrderStatus.CourierFinding,
          OrderStatus.CourierConfirmation
        ].contains(order.status)));
    tmp.addAll(shownOrders.where((order) => [
          OrderStatus.FailureByCourier,
          OrderStatus.FailureByRestaurant
        ].contains(order.status)));
    tmp.addAll(shownOrders.where((order) => [
          OrderStatus.Cooking,
        ].contains(order.status)));
    tmp.addAll(shownOrders.where((order) => [
          OrderStatus.Delivering,
          OrderStatus.ReadyForDelivery,
        ].contains(order.status)));
    shownOrders = tmp;

    notifyListeners();
  }

  void orderReady(BuildContext context, Order order) {
    Order newOrder = order;
    newOrder.status = OrderStatus.ReadyForDelivery;
    int ind = shownOrders.indexOf(order);
    if (ind != -1) {
      shownOrders.remove(order);
      notifyListeners();
      shownOrders.insert(ind, newOrder);
    }
    ind = orders.indexOf(order);
    if (ind != -1) {
      orders.remove(order);
      notifyListeners();
      orders.insert(ind, newOrder);
    }
    print('a');

    //TODO: impl api
    notifyListeners();
  }

  LatLng? get location => x == null && y == null ? null : LatLng(x!, y!);
}
