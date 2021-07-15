import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/widgets/map/map_marker.dart';

class Map extends StatefulWidget {
  final List<MapMarker> markers;
  final LatLng? center;
  final void Function(MapMarker)? onTap;
  const Map({
    Key? key,
    this.markers = const [],
    this.center,
    this.onTap,
  }) : super(key: key);

  @override
  _MapState createState() => _MapState(this.markers);
}

class _MapState extends State<Map> {
  final List<MapMarker> _markers;

  _MapState(this._markers);

  // void pick(MapMarker mapMarker) {
  //   setState(() {
  //     for (MapMarker marker in _markers) {
  //       marker.picked = marker == mapMarker;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: widget.center ?? MapMarker.defaultCenter,
        zoom: 13,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
            markers: _markers
                .map(
                  (marker) => Marker(
                    width: 25,
                    height: 25,
                    point: marker.location,
                    builder: (context) => marker.widget,
                  ),
                )
                .toList()),
      ],
    );
  }
}
