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

class Order {
  int? id, restaurantId, sessionId, total;
  String? fromAddress, toAddress, courierName;
  LatLng? fromLatLng, toLatLng;
  double? appearance, behavior, sum;
  List<int>? start, stop;
  OrderStatus? status;
  bool? withCash;

  Order.shis(this.id, this.sum, this.status, this.courierName, this.toAddress);

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        restaurantId = json['restaurant_id'],
        sessionId = json['session_id'],
        total = json['coocking_time'],
        //fromAddress = json['']
        toAddress = json['delivery_address'],
        //fromLatLng = json['']
        toLatLng = LatLng(json['address_lat'], json['address_lng']),
        withCash = json['method'] == 'Cash',
        //appearance, behavior
        start = parseNaiveDateTime(json['take_datetime']),
        stop = parseNaiveDateTime(json['delivery_datetime']),
        sum = json['courier_share'] / 100;

  String get jsonID => jsonEncode({"id": id});
}
