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
    print('');
    print('route: $route');
    print('code: ${response.statusCode}');
    print('body: ${utf8.decode(response.body.codeUnits)}');
    print('');
    if (response.statusCode == 200)
      return utf8.decode(response.body.codeUnits);
    else if (response.statusCode == 500 &&
        jsonDecode(utf8.decode(response.body.codeUnits))['message']
            .contains('Signature')) {
      if (!await logIn(context))
        throw Exception(utf8.decode(response.body.codeUnits));
    } else
      throw Exception(utf8.decode(response.body.codeUnits));
  }
}

/// LOGIN sector

Future<bool> logIn(BuildContext context) async {
  try {
    Map<String, dynamic> data = context.read<Restaurant>().loginData;
    String _json = await apiRequest(
      context: context,
      route: '/api/users/login',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    Map<String, dynamic> json = jsonDecode(_json).cast<String, dynamic>();
    context.read<Restaurant>().fromJson(json);
  } catch (_) {
    context.read<Restaurant>().unlogin();
  }
  return context.read<Restaurant>().logined;
}

/// GET DATA sector

Future<void> getAlerts(BuildContext context) async {
  String json = await apiRequest(
    context: context,
    route: '/api/users/restaurants/order_info',
  );

  var parsedJson = jsonDecode(json);

  List<Map<String, dynamic>> coo =
      parsedJson['coords'].cast<Map<String, dynamic>>();

  List<Map<String, dynamic>> ord =
      parsedJson['orders'].cast<Map<String, dynamic>>();

  context
      .read<Restaurant>()
      .setOrders(ord.map<Order>((json) => Order.fromJson(json, coo)).toList());
}

Future<void> getOrdersHistory(BuildContext context) async {
  String json = await apiRequest(
    context: context,
    route: '/api/users/restaurants/order_history',
  );

  List<Map<String, dynamic>> ord =
      jsonDecode(json).cast<Map<String, dynamic>>();

  try {
    Order.historyFromJson(ord[0]);
  } catch (e) {
    print(e.toString());
  }

  context.read<Restaurant>().setOrdersHistory(
      ord.map<Order>((json) => Order.historyFromJson(json)).toList());
}

/// GET TEMPORARY DATA sector

Future<LatLng?> getLatLng(BuildContext context, String address) async {
  try {
    String json = await apiRequest(
      context: context,
      route: '/api/ordering/get_coords_by_address',
      body: jsonEncode({'address': address}),
    );

    Map<String, dynamic> decodedJson = jsonDecode(json);

    double? lat = decodedJson['lat'];
    double? lng = decodedJson['lng'];

    return (lat != null && lng != null) ? LatLng(lat, lng) : null;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<double> getDeliverySum(
  BuildContext context,
  bool bigOrder,
  LatLng toLatLng,
  LatLng fromLatLng,
) async {
  try {
    String json = await apiRequest(
      context: context,
      route: '/api/ordering/get_route_cost',
      body: jsonEncode({
        'to_lat': toLatLng.latitude,
        'to_lng': toLatLng.longitude,
        'from_lat': fromLatLng.latitude,
        'from_lng': fromLatLng.longitude,
      }),
    );

    int cost = jsonDecode(json)['cost'];

    return ((bigOrder ? 100 : 90) + cost / 100);
  } catch (e) {
    print(e.toString());
    return -1;
  }
}

/// ACTION sector

Future<bool> createOrder(
  BuildContext context,
  Order order,
) async {
  try {
    print(order.json(context.read<Restaurant>().id!));
    await apiRequest(
      context: context,
      route: '/api/ordering/new',
      body: order.json(context.read<Restaurant>().id!),
    );
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> setReadyForDelivery(
  BuildContext context,
  Order order,
) async {
  try {
    await apiRequest(
      context: context,
      route: '/api/ordering/set_ready_for_delivery_order',
      body: order.jsonID,
    );
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> rateCourier(
  BuildContext context,
  Order order,
  List<int> rating,
) async {
  try {
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
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> cancelOrder(
  BuildContext context,
  Order order,
  OrderFaultType type,
  String comment,
) async {
  try {
    await apiRequest(
      context: context,
      route: '/api/ordering/finalize_order',
      body: jsonEncode({
        'order_id': order.id,
        'is_success': false,
        'courier_fault': type == OrderFaultType.ByCourier,
        'comment': comment,
      }),
    );
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
