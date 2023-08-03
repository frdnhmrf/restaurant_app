import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/bloc/detail_product/detail_product_bloc.dart';
import 'package:restaurant_app/bloc/gmap_bloc/gmap_bloc.dart';
import 'package:restaurant_app/presentation/pages/direction_page.dart';

class DetailRestaurantPage extends StatefulWidget {
  static const routeName = '/detail-restaurant';
  final int id;
  const DetailRestaurantPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<DetailRestaurantPage> createState() => _DetailRestaurantPageState();
}

class _DetailRestaurantPageState extends State<DetailRestaurantPage> {
  @override
  void initState() {
    context.read<DetailProductBloc>().add(DetailProductEvent.get(widget.id));
    super.initState();
  }

  final Set<Marker> markers = {};

  void createMarker(double lat, double lng, String address) async {
    final marker = Marker(
      markerId: const MarkerId("currentPosition"),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: address),
    );

    markers.add(marker);
  }

  LatLng? destinationPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Restaurant"),
      ),
      body: BlocBuilder<DetailProductBloc, DetailProductState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const Center(child: Text("No detail appear")),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (model) {
              context
                  .read<GmapBloc>()
                  .add(const GmapEvent.getCurrentLocation());
              final lat = double.parse(model.data.attributes.latitude);
              final lng = double.parse(model.data.attributes.longitude);
              destinationPosition = LatLng(lat, lng);
              createMarker(lat, lng, model.data.attributes.address);

              return ListView(
                children: [
                  Image.network(
                    model.data.attributes.photo ??
                        'https://picsum.photos/200/300',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(model.data.attributes.name),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(model.data.attributes.description),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(model.data.attributes.address),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            markers: markers,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                lat,
                                lng,
                              ),
                              zoom: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        BlocBuilder<GmapBloc, GmapState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () {
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                              error: (error) {
                                return ScaffoldMessenger(
                                    child: SnackBar(
                                  content: Text("Error : $error"),
                                ));
                              },
                              loaded: (model) {
                                return ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DirectionPage(
                                                origin: model.latLng!,
                                                destination:
                                                    destinationPosition!,
                                              )),
                                    );
                                  },
                                  child: const Text('Direction'),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
