import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Restaurant with ChangeNotifier {
  int? id;
  double? x, y;
  String? name, address, phone, password;
  List<int>? open, close;

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
        close = [20, 0];

  LatLng? get location => x == null && y == null ? null : LatLng(x!, y!);
}
