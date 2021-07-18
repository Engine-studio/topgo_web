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

  late List<Order> orders, shownOrders, ordersHistory, shownOrdersHistory;

  Restaurant()
      : id = 0,
        x = 51.667627,
        y = 39.192717,
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
            LatLng(
              51.669489 + (i % 2 == 0 ? 1 : -1) * (i + 1) * 0.01,
              39.156785 + (i % 2 == 0 ? 1 : -1) * (i + 1) * 0.01,
            ),
            LatLng(
              51.669489 - (i % 2 == 0 ? 1 : -1) * (i + 1) * 0.006,
              39.156785 + (i % 2 == 0 ? 1 : -1) * (i + 1) * 0.006,
            ),
          ),
        )
        .toList();
    shownOrders = orders;

    ordersHistory = [1, 2, 3, 4, 5, 6, 7]
        .map(
          (i) => Order.shis(
            i * 13,
            i * 1250,
            OrderStatus.Success,
            'Константинов Абдурахмент Ибн Иль Амирович',
            "toAddr esstoAdd rasdasd" * i,
            LatLng(
              51.669489 + (i % 2 == 0 ? 1 : -1) * (i + 1) * 0.01,
              39.156785 + (i % 2 == 0 ? 1 : -1) * (i + 1) * 0.01,
            ),
            LatLng(
              51.669489 - (i % 2 == 0 ? 1 : -1) * (i + 1) * 0.006,
              39.156785 + (i % 2 == 0 ? 1 : -1) * (i + 1) * 0.006,
            ),
          ),
        )
        .toList();
    shownOrdersHistory = ordersHistory;

    formatShown();
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

  void formShownHistory({required String text}) {
    shownOrdersHistory = ordersHistory;
    shownOrdersHistory = List.from(
      shownOrdersHistory.where(
        (order) =>
            order.courierName!.contains(text) ||
            order.id!.toString().contains(text) ||
            order.toAddress!.contains(text) ||
            order.sum!.toString().contains(text) ||
            moneyString(order.sum!).contains(text),
      ),
    );

    notifyListeners();
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
    tmp.addAll(shownOrders.where((order) => [
          OrderStatus.Delivered,
        ].contains(order.status)));
    shownOrders = tmp;

    notifyListeners();
  }

  Future<void> orderReady(BuildContext context, Order order) async {
    int ind = shownOrders.indexOf(order);
    if (ind != -1) shownOrders[ind].status = OrderStatus.ReadyForDelivery;
    ind = orders.indexOf(order);
    if (ind != -1) orders[ind].status = OrderStatus.ReadyForDelivery;

    //TODO: impl api
    notifyListeners();
  }

  Future<void> orderCancel(BuildContext context, Order order) async {
    shownOrders.remove(order);
    orders.remove(order);

    //TODO: impl api
    notifyListeners();
  }

  Future<void> orderRate(
    BuildContext context,
    Order order,
    List<int> rating,
  ) async {
    int ind = shownOrders.indexOf(order);
    if (ind != -1) {
      shownOrders[ind].status = OrderStatus.Success;
      shownOrders[ind].appearance = rating[0] as double?;
      shownOrders[ind].behavior = rating[1] as double?;
    }
    ind = orders.indexOf(order);
    if (ind != -1) {
      orders[ind].status = OrderStatus.Success;
      orders[ind].appearance = rating[0] as double?;
      orders[ind].behavior = rating[1] as double?;
    }

    ordersHistory.add(orders[ind]);

    //TODO: impl api
    notifyListeners();
  }

  int get alertsCount =>
      orders.where((order) => order.status != OrderStatus.Success).length;

  LatLng? get location => x == null && y == null ? null : LatLng(x!, y!);
}
