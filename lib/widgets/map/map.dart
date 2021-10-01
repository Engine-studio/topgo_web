import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/widgets/close_button.dart';
import 'package:topgo_web/widgets/map/map_marker.dart';
import 'package:topgo_web/widgets/map/zoom.dart';

class Map extends StatefulWidget {
  final List<MapMarker> markers;
  final LatLng? center;
  final int? id;
  final double zoom;
  final void Function(int)? onTap;
  final void Function()? closeFunction;

  const Map({
    Key? key,
    this.markers = const [],
    this.center,
    this.onTap,
    this.id,
    this.zoom = 14,
    this.closeFunction,
  }) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  late List<MapMarker> _markers;
  final MapController controller = MapController();

  void pick(MapMarker mapMarker) {
    int? ind;
    setState(
      () {
        if (mapMarker.role != Role.Restaurant)
          for (MapMarker marker in _markers) {
            marker.picked = marker.id == mapMarker.id;
            if (marker.id == mapMarker.id) ind = marker.id;
          }
        _markers[0].picked = true;
      },
    );
    if (ind != null) widget.onTap!(ind!);
  }

  @override
  Widget build(BuildContext context) {
    this._markers = widget.markers;
    if (widget.id != null) {
      for (MapMarker marker in _markers) marker.picked = marker.id == widget.id;
      _markers[0].picked = true;
    }
    return Stack(
      children: [
        FlutterMap(
          mapController: controller,
          options: MapOptions(
            center: widget.center ?? MapMarker.defaultCenter,
            zoom: widget.zoom,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(
              markers: _markers
                  .map(
                    (marker) => Marker(
                      width: 25,
                      height: 25,
                      point: marker.location,
                      builder: (context) => GestureDetector(
                        onTap: () => pick(marker),
                        child: marker.widget,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        Row(
          children: [
            if (widget.closeFunction != null)
              GestureDetector(
                onTap: widget.closeFunction,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  child: CloseButton(white: true),
                ),
              ),
            Spacer(),
            GestureDetector(
              onTap: () =>
                  controller.move(controller.center, controller.zoom - 0.5),
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Zoom(),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  controller.move(controller.center, controller.zoom + 0.5),
              child: Container(
                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Zoom(out: false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
