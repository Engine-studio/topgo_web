import 'dart:convert' show jsonEncode;

import 'package:latlong2/latlong.dart';
import 'package:topgo_web/functions/naive_time.dart';

enum OrderStatus {
  CourierFinding,
  CourierConfirmation,
  Cooking,
  ReadyForDelivery,
  Delivering,
  Delivered,
  FailureByCourier,
  FailureByRestaurant,
  Success
}

enum OrderPayment {
  Terminal,
  Cash,
  Payed,
}

enum OrderFaultType {
  ByRestaurant,
  ByCourier,
}

class Order {
  int? id, courierId;
  String? toAddress, courierName, courierPhone, clientPhone, body, comment;
  LatLng? toLatLng, courierLatLng;
  double? rate, sum;
  bool? big;
  List<int>? cookingTime;
  OrderStatus? status;
  OrderPayment? paymentType;

  String get jsonID => jsonEncode({"id": id});

  Order.fromJson(
    Map<String, dynamic> json,
    List<Map<String, dynamic>> coords,
  )   : id = json['order_id'],
        toAddress = json['delivery_address'],
        courierName =
            '${json['courier_surname']} ${json['courier_name']} ${json['courier_patronymic']}',
        courierPhone = json['courier_phone'],
        clientPhone = json['client_phone'],
        body = json['details'],
        comment = json['client_comment'],
        toLatLng = LatLng(json['address_lat'], json['address_lng']),
        rate = double.parse((double.parse(json['courier_rate_count'] ??
                0 / json['courier_rate_amount'] ??
                1)
            .toStringAsFixed(2))),
        sum = json['order_price'] / 100,
        status = json['order_status'],
        paymentType = json['method'],
        cookingTime = parseNaiveTime(json['cooking_time']),
        big = json['is_big_order'],
        courierId = json['courier_id'] {
    for (Map<String, dynamic> c in coords)
      if (c['courier_id'] == json['courier_id']) {
        courierLatLng = LatLng(c['lat'], c['lng']);
        break;
      }
  }

  Order.historyFromJson(Map<String, dynamic> json)
      : id = json['order_id'],
        toAddress = json['delivery_address'],
        courierName =
            '${json['courier_surname']} ${json['courier_name']} ${json['courier_patronymic']}',
        courierPhone = json['courier_phone'],
        clientPhone = json['client_phone'],
        body = json['details'],
        comment = json['client_comment'],
        toLatLng = LatLng(json['address_lat'], json['address_lng']),
        courierLatLng = null,
        rate = double.parse((double.parse(json['courier_rate_count'] ??
                0 / json['courier_rate_amount'] ??
                1)
            .toStringAsFixed(2))),
        sum = json['order_price'] / 100,
        status = json['order_status'],
        paymentType = json['method'],
        cookingTime = null,
        big = null,
        courierId = null;
}
