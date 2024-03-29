import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/functions/money_string.dart';
import 'package:topgo_web/functions/naive_time.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/widgets/search.dart';

class Restaurant with ChangeNotifier {
  bool logined;
  int? id;
  LatLng? latLng;
  String? name, address, phone, password, token;
  List<int>? open, close;

  List<Order> orders = [],
      shownOrders = [],
      ordersHistory = [],
      shownOrdersHistory = [];

  Restaurant() : logined = false;

  Map<String, String> get loginData => {
        'phone': phone ?? '',
        'password': password ?? '',
      };

  void setLoginData(String phone, String password) {
    this.phone = phone;
    this.password = password;
  }

  void fromJson(Map<String, dynamic> json) {
    token = json['jwt'];
    json = json['restaurant'] as Map<String, dynamic>;
    logined = false;
    if (json['is_deleted']) return;
    logined = true;
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latLng = LatLng(json['location_lat'], json['location_lng']);
    open = parseNaiveTime(json['working_from'][0]);
    close = parseNaiveTime(json['working_till'][0]);
    orders = [];
    ordersHistory = [];
    shownOrders = [];
    shownOrdersHistory = [];
    notifyListeners();
  }

  void unlogin() {
    token = null;
    logined = false;
    id = null;
    name = null;
    address = null;
    latLng = null;
    open = null;
    close = null;
  }

  void setOrders(List<Order> orders) {
    this.orders = orders;
    this.shownOrders = [];
    this.shownOrders.addAll(orders.where((order) => [
          OrderStatus.CourierFinding,
          OrderStatus.CourierConfirmation
        ].contains(order.status)));
    this.shownOrders.addAll(orders.where((order) => [
          OrderStatus.Cooking,
        ].contains(order.status)));
    this.shownOrders.addAll(orders.where((order) => [
          OrderStatus.Delivering,
          OrderStatus.ReadyForDelivery,
        ].contains(order.status)));
    this.shownOrders.addAll(orders.where((order) => [
          OrderStatus.Delivered,
        ].contains(order.status)));

    notifyListeners();
  }

  void setOrdersHistory(List<Order> orders) {
    this.ordersHistory = orders;
    this.shownOrdersHistory = orders;
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
            (order.courierName != null && order.courierName!.contains(text)) ||
            order.id!.toString().contains(text) ||
            order.toAddress!.contains(text) ||
            order.sum!.toString().contains(text) ||
            moneyString(order.sum!).contains(text),
      ),
    );

    List<Order> tmp = [];
    tmp.addAll(shownOrders.where((order) => [
          OrderStatus.CourierFinding,
          OrderStatus.CourierConfirmation
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
    this.shownOrders = tmp;

    notifyListeners();
  }

  void formShownHistory({required String text}) {
    shownOrdersHistory = ordersHistory;
    shownOrdersHistory = List.from(
      shownOrdersHistory.where(
        (order) =>
            (order.courierName != null && order.courierName!.contains(text)) ||
            order.id!.toString().contains(text) ||
            order.toAddress!.contains(text) ||
            order.sum!.toString().contains(text) ||
            moneyString(order.sum!).contains(text),
      ),
    );

    notifyListeners();
  }

  void orderReady(BuildContext context, Order order) {
    int ind = shownOrders.indexOf(order);
    if (ind != -1) shownOrders[ind].status = OrderStatus.ReadyForDelivery;
    ind = orders.indexOf(order);
    if (ind != -1) orders[ind].status = OrderStatus.ReadyForDelivery;

    notifyListeners();
  }

  void orderCancel(
    BuildContext context,
    Order order,
    OrderFaultType type,
    String comment,
  ) {
    shownOrders.remove(order);
    orders.remove(order);

    notifyListeners();
  }

  void orderRate(
    BuildContext context,
    Order order,
    List<int> rating,
  ) {
    int ind = shownOrders.indexOf(order);
    if (ind != -1) {
      shownOrders[ind].status = OrderStatus.Success;
      shownOrders[ind].rate =
          double.parse(((rating[0] + rating[1]) / 2).toStringAsFixed(2));
    }
    ind = orders.indexOf(order);
    if (ind != -1) {
      orders[ind].status = OrderStatus.Success;
      orders[ind].rate =
          double.parse(((rating[0] + rating[1]) / 2).toStringAsFixed(2));
    }

    notifyListeners();
  }

  int get alertsCount => orders
      .where((order) => ![
            OrderStatus.Success,
            OrderStatus.FailureByCourier,
            OrderStatus.FailureByRestaurant
          ].contains(order.status))
      .length;
}
