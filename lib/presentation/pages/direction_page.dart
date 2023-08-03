// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:restaurant_app/data/models/direction.dart';

class DirectionPage extends StatefulWidget {
  const DirectionPage({
    Key? key,
    required this.origin,
    required this.destination,
  }) : super(key: key);

  final LatLng origin;
  final LatLng destination;

  @override
  State<DirectionPage> createState() => _DirectionPageState();
}

class _DirectionPageState extends State<DirectionPage> {
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};

  final Set<Polyline> polylines = <Polyline>{};

  final Location location = Location();

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            "assets/markers/car.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  Future<void> setupLocation() async {
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        debugPrint("Service not enabled");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.denied) {
        debugPrint("Permission not granted");
        return;
      }
    }
  }

  bool isNavigationOn = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await setupLocation();
    });

    location.onLocationChanged.listen((event) {
      if (isNavigationOn) {
        final latlng = LatLng(event.latitude!, event.longitude!);
        CameraPosition cameraPosition = CameraPosition(
          target: latlng,
          zoom: 16,
          tilt: 80,
          bearing: 30,
        );
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );

        setState(() {
          markers.removeWhere((element) => element.markerId.value == "source");
          markers.add(Marker(
            markerId: const MarkerId("source"),
            position: latlng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueCyan,
            ),
          ));
        });
      }
    });
  }

  Future<void> setPolylines(LatLng origin, LatLng destination) async {
    final result = await Direction.getDirections(
      googleMapsApiKey: 'AIzaSyDibqZy4BQxwm3oM1BS57VmEEhKH_Ug1fU',
      origin: origin,
      destination: destination,
    );

    final polylineCoordinates = <LatLng>[];
    if (result != null && result.polylinePoints.isNotEmpty) {
      polylineCoordinates.addAll(result.polylinePoints);
    }

    final polyline = Polyline(
      polylineId: const PolylineId('default-polyline'),
      color: Colors.amber,
      width: 7,
      points: polylineCoordinates,
    );

    setState(() {
      polylines.add(polyline);
    });

    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(result!.bounds, 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.origin,
              zoom: 18,
            ),
            markers: markers,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            polylines: polylines,
            onMapCreated: (controller) {
              final originMarker = Marker(
                markerId: const MarkerId('source'),
                position: widget.origin,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              );

              final destinationMarker = Marker(
                markerId: const MarkerId('destination'),
                position: widget.destination,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              );

              setState(() {
                mapController = controller;
                markers.addAll([originMarker, destinationMarker]);
              });
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    markers.removeWhere(
                        (element) => element.markerId.value == "source");
                    markers.add(Marker(
                      markerId: const MarkerId('source'),
                      position: widget.origin,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueYellow,
                      ),
                    ));

                    markers.add(Marker(
                      markerId: const MarkerId('des'),
                      position: widget.origin,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ));
                    setState(() {});
                    await setPolylines(widget.origin, widget.destination);
                  },
                  child: const Icon(Icons.navigation),
                ),
                const SizedBox(
                  height: 8,
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isNavigationOn = true;
                    });
                  },
                  child: const Icon(Icons.run_circle),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
