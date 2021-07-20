import 'dart:convert' show utf8, jsonDecode, jsonEncode;

import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/models/restaurant.dart';

const host = "topgo.club";

Map<String, String> jsonHeader(BuildContext context) => {
      'Content-Type': 'application/json',
      'jwt': context.read<Restaurant>().token ?? ''
    };

/// Returns utf8 decoded codeUnits of response from server.
///
/// If headers is null uses jsonHeader with token.
/// Required route format - `/api/route_name`.
Future<String> apiRequest({
  required BuildContext context,
  required String route,
  Map<String, String>? headers,
  Object? body,
}) async {
  while (true) {
    http.Response response = await http.post(
      Uri.https(host, route),
      headers: headers ?? jsonHeader(context),
      body: body,
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200)
      return utf8.decode(response.body.codeUnits);
    else if (response.statusCode == 500 &&
        jsonDecode(utf8.decode(response.body.codeUnits))['message']
            .contains('Signature')) {
      if (!await logIn(context)) throw Exception('Unable to log in');
    } else
      throw Exception('Unable to connect to the server');
  }
}

Future<bool> logIn(BuildContext context) async {
  Map<String, dynamic> data = context.read<Restaurant>().loginData;
  String _json = await apiRequest(
    context: context,
    route: '/api/users/login',
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  Map<String, dynamic> json = jsonDecode(_json).cast<String, dynamic>();

  context.read<Restaurant>().fromJson(json);

  return context.read<Restaurant>().logined;
}

Future<void> getAlerts(BuildContext context) async {
  String json = await apiRequest(
    context: context,
    route: '/api/users/restaurants/order_info',
  );

  Map<String, dynamic> parsedJson = jsonDecode(json);

  context.read<Restaurant>().setOrders(
        parsedJson['orders']
            .cast<Map<String, dynamic>>()
            .map<Order>((json) => Order.fromJson(
                json, parsedJson['coords'].cast<Map<String, dynamic>>()))
            .toList(),
      );
}

Future<void> getOrdersHistory(BuildContext context) async {
  String json = await apiRequest(
    context: context,
    route: '/api/users/restaurants/order_history',
  );

  context.read<Restaurant>().setOrdersHistory(
        jsonDecode(json)
            .cast<Map<String, dynamic>>()
            .map<Order>((json) => Order.historyFromJson(json))
            .toList(),
      );
}

Future<LatLng?> getLatLng(BuildContext context, String address) async {
  String json = await apiRequest(
    context: context,
    route: '/api/ordering/get_coords_by_address',
  );

  Map<String, dynamic> decodedJson = jsonDecode(json);

  double? lat = decodedJson['lat'];
  double? lng = decodedJson['lng'];

  return (lat != null && lng != null) ? LatLng(lat, lng) : null;
}

Future<void> rateCourier(
  BuildContext context,
  Order order,
  List<int> rating,
) async {
  await apiRequest(
    context: context,
    route: '/api/ordering/rate_courier',
    body: jsonEncode({
      'courier_id': order.courierId,
      'order_id': order.id,
      'look': rating[0],
      'politeness': rating[1],
    }),
  );
}

Future<void> setReadyForDelivery(
  BuildContext context,
  Order order,
) async {
  await apiRequest(
    context: context,
    route: '/api/ordering/set_ready_for_delivery_order',
    body: order.jsonID,
  );
}

Future<void> cancelOrder(
  BuildContext context,
  Order order,
  OrderFaultType type,
  String comment,
) async {
  await apiRequest(
    context: context,
    route: '/api/ordering/set_ready_for_delivery_order',
    body: jsonEncode({
      'order_id': order.id,
      'is_success': false,
      'courier_fault': type == OrderFaultType.ByCourier,
      'comment': comment,
    }),
  );
}
