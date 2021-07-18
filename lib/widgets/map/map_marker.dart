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
  int? id;
  Role role;
  double? x, y;
  bool picked;

  static LatLng get defaultCenter => LatLng(51.667627, 39.192717);

  MapMarker()
      : picked = false,
        role = Role.Client;

  MapMarker.restaurant(Restaurant self)
      : role = Role.Restaurant,
        x = self.x,
        y = self.y,
        picked = false;

  MapMarker.client(this.id, this.x, this.y, {this.picked = false})
      : role = Role.Client;

  MapMarker.courier(this.id, this.x, this.y, {this.picked = false})
      : role = Role.Courier;

  LatLng get location => LatLng(x ?? 0, y ?? 0);

  Widget get widget => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: picked
              ? GrdStyle.select
              : LinearGradient(colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                ]),
        ),
        child: Center(
          child: Image.asset(
            role == Role.Restaurant
                ? 'assets/icons/store.png'
                : role == Role.Courier
                    ? 'assets/icons/user.png'
                    : 'assets/icons/home.png',
            height: role == Role.Client ? 18 : 20,
            color: picked ? Color(0xFFFFFFFF) : ClrStyle.icons,
          ),
        ),
      );

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
