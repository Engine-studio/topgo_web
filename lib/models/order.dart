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
  Card,
  Cash,
  AlreadyPayed,
}

enum OrderFaultType {
  ByRestaurant,
  ByCourier,
}

class Order {
  int? id, courierId;
  String? toAddress, courierName, courierPhone, clientPhone, body, comment;
  LatLng? toLatLng, courierLatLng;
  double? rate, sum, deliverySum;
  bool? big;
  List<int>? cookingTime;
  OrderStatus? status;
  OrderPayment? paymentType;

  String get jsonID => jsonEncode({"id": id});

  Order.create({
    required this.toAddress,
    required this.clientPhone,
    required this.body,
    required this.comment,
    required this.sum,
    required this.big,
    required this.cookingTime,
    required this.paymentType,
    required this.deliverySum,
    required this.toLatLng,
  });

  String json(int restaurantId) => jsonEncode({
        'restaurant_id': restaurantId,
        'details': body,
        'is_big_order': big,
        'delivery_address': toAddress,
        'method': paymentType.toString().replaceAll('OrderPayment.', ''),
        'courier_share': ((deliverySum! - 15) * 100).toInt(),
        'order_price': (sum! * 100).toInt(),
        'cooking_time': toNaiveTime(cookingTime!),
        'client_phone': clientPhone,
        'client_comment': comment,
        'address_lat': toLatLng!.latitude,
        'address_lng': toLatLng!.longitude,
      });

  Order.fromJson(
    Map<String, dynamic> json,
    List<Map<String, dynamic>> coords,
  )   : id = json['order_id'],
        toAddress = json['delivery_address'],
        clientPhone = json['client_phone'],
        body = json['details'],
        comment = json['client_comment'],
        toLatLng = LatLng(json['address_lat'], json['address_lng']),
        sum = json['order_price'] / 100,
        status = OrderStatus.values
            .firstWhere((e) => e.toString() == 'OrderStatus.' + json['status']),
        paymentType = OrderPayment.values.firstWhere(
            (e) => e.toString() == 'OrderPayment.' + json['method']),
        cookingTime = parseNaiveTime(json['cooking_time']),
        big = json['is_big_order'],
        courierId = json['courier_id'] {
    if (json['courier_id'] != null) {
      rate = double.parse(((json['courier_rate_amount'] ?? 0) /
              (json['courier_rate_count'] ?? 1))
          .toStringAsFixed(2));
      courierPhone = json['courier_phone'].toString();
      courierName =
          '${json['courier_surname']} ${json['courier_name']} ${json['courier_patronymic']}';
      for (Map<String, dynamic> c in coords)
        if (c['courier_id'] == this.courierId) {
          courierLatLng = LatLng(c['lat'], c['lng']);
          break;
        }
    }
  }

  Order.historyFromJson(Map<String, dynamic> json)
      : id = json['order_id'],
        toAddress = json['delivery_address'],
        clientPhone = json['client_phone'],
        body = json['details'],
        comment = json['client_comment'],
        toLatLng = LatLng(json['address_lat'], json['address_lng']),
        sum = json['order_price'] / 100,
        status = OrderStatus.values
            .firstWhere((e) => e.toString() == 'OrderStatus.' + json['status']),
        paymentType = OrderPayment.values.firstWhere(
            (e) => e.toString() == 'OrderPayment.' + json['method']),
        cookingTime = parseNaiveTime(json['cooking_time']),
        big = json['is_big_order'],
        courierId = json['courier_id'] {
    if (json['courier_id'] != null) {
      rate = double.parse(((json['courier_rate_amount'] ?? 0) /
              (json['courier_rate_count'] ?? 1))
          .toStringAsFixed(2));
      courierPhone = json['courier_phone'].toString();
      courierName =
          '${json['courier_surname']} ${json['courier_name']} ${json['courier_patronymic']}';
    }
  }
}
