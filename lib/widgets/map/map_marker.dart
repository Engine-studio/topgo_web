import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';

enum Role {
  Restaurant,
  Courier,
  Client,
}

class MapMarker {
  Role role;
  double? x, y;
  bool picked;

  static LatLng get defaultCenter => LatLng(0, 0);

  MapMarker()
      : picked = false,
        role = Role.Client;

  MapMarker.restaurant(Restaurant self)
      : role = Role.Restaurant,
        x = self.x,
        y = self.y,
        picked = false;

  LatLng get location => LatLng(x ?? 0, y ?? 0);

  Widget get widget {
    if (this.role == Role.Restaurant)
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color(0xFFFFFFFF),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/store.png',
            width: 20,
            height: 20,
            color: ClrStyle.icons,
          ),
        ),
      );
    return Container();
  }

  // SimpleCourier? courier;
  // Restaurant? restaurant;

  // Widget Function()? build;

  // MapMarker({required this.x, required this.y}) : picked = false;

  // MapMarker.courier({required this.courier}) : picked = false {
  //   this.x = courier!.x ?? 0;
  //   this.y = courier!.y ?? 0;
  //   this.build = () => CourierCard(courier: courier!, forMap: true);
  // }

  // MapMarker.restaurant({required this.restaurant}) : picked = false {
  //   this.x = restaurant!.x ?? 0;
  //   this.y = restaurant!.y ?? 0;
  //   this.build = () => RestaurantCard(restaurant: restaurant!, forMap: true);
  // }

  // MapMarker.restaurantNoCard({required this.restaurant}) : picked = false {
  //   this.x = restaurant!.x ?? 0;
  //   this.y = restaurant!.y ?? 0;
  // }

  // Widget get waitingWidget => Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(6),
  //         color: Color(0xFFFFFFFF),
  //       ),
  //       child: Center(
  //         child: Image(
  //           image: AssetImage(
  //             restaurant != null
  //                 ? 'assets/icons/store.png'
  //                 : 'assets/icons/user.png',
  //           ),
  //           width: 18,
  //           height: 18,
  //           color: ClrStyle.icons,
  //         ),
  //       ),
  //     );
  // Widget get pickedWidget => Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(6),
  //         color: Color(0xFFFFFFFF),
  //         gradient: GrdStyle.select,
  //       ),
  //       child: Center(
  //         child: Image(
  //           image: AssetImage(
  //             restaurant != null
  //                 ? 'assets/icons/store.png'
  //                 : 'assets/icons/user.png',
  //           ),
  //           width: 18,
  //           height: 19,
  //           color: ClrStyle.lightBackground,
  //         ),
  //       ),
  //     );
}
