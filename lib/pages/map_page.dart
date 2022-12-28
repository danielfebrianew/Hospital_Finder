import 'dart:async';
import 'package:hospital_finder/provider/map_provider.dart';
import 'package:hospital_finder/widgets/map_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

const _mainColor = Color(0xff26264D);
const _secondaryColor = Color(0xffDBDBE5);

class _MapPageState extends State<MapPage> {
  late MapController _mapController;
  List<Place>? searchPlaces;
  late final StreamSubscription<MapEvent> mapEventSubscription;
  var markers = <Marker>[];
  IconData icon = Icons.gps_not_fixed;
  int _eventKey = 0;
  final bounds = LatLngBounds();
  // Place? _tapPlace;

  @override
  void initState() {
    _mapController = MapController();
    mapEventSubscription = _mapController.mapEventStream.listen(onMapEvent);
    super.initState();
  }

  void setIcon(IconData newIcon) {
    if (newIcon != icon && mounted) {
      setState(() {
        icon = newIcon;
      });
    }
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is MapEventMove && mapEvent.id != _eventKey.toString()) {
      setIcon(Icons.gps_not_fixed);
    }
  }

  @override
  void didChangeDependencies() {
    // searchLocation();
    searchPlaces?.forEach((element) {
      bounds.extend(LatLng(element.lat, element.lon));
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var map = Provider.of<MapProvider>(context, listen: false);
    map.addMarker(context, _mapController);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: FutureBuilder(
              future: Provider.of<MapProvider>(context, listen: false)
                  .searchLocation(),
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Consumer<MapProvider>(
                          builder: (context, places, child) =>
                              places.mapPlaces.isEmpty
                                  ? child!
                                  : Flexible(
                                      child: FlutterMap(
                                        mapController: _mapController,
                                        options: MapOptions(
                                          center: map.mapItem.cityCoordinate ??
                                              LatLng(-7.8011945, 110.364917),
                                          zoom: 12,
                                          maxZoom: 100,
                                          minZoom: 3,
                                        ),
                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            userAgentPackageName:
                                                'com.example.hospital_finder',
                                            subdomains: const ['a', 'b', 'c'],
                                          ),
                                          MarkerLayer(
                                            markers: map.markers,
                                          )
                                        ],
                                      ),
                                    ),
                          child: const Flexible(
                            child: Center(
                              child: Text('Belum ditemukan!'),
                            ),
                          ),
                        ),
            ),
          ),
          Positioned(
            top: 60,
            left: 10,
            child: Builder(
              builder: (context) {
                return FloatingActionButton(
                  backgroundColor: _mainColor,
                  foregroundColor: _secondaryColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.arrow_back),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void addMarker() {
    final places = Provider.of<MapProvider>(context).mapPlaces;

    markers.addAll(
      places.map(
        (e) => Marker(
          width: 80,
          height: 80,
          point: LatLng(e.lat, e.lon),
          builder: (ctx) => Container(
            key: Key(e.placeId.toString()),
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.location_on,
                color: _mainColor,
              ),
              onPressed: () => {
                _mapController.move(LatLng(e.lat, e.lon), 12),
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (ctx) => MapBottomSheet(place: e),
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
