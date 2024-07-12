import 'package:dars75_yandexmap_restaurant/controllers/restaurants_controller.dart';
import 'package:dars75_yandexmap_restaurant/models/restaurant.dart';
import 'package:dars75_yandexmap_restaurant/services/yandex_map_service.dart';
import 'package:dars75_yandexmap_restaurant/views/screens/restaurants_screen.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {

  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late YandexMapController mapController;
  final searchContoller = TextEditingController();
  final nameController = TextEditingController();
  List<MapObject> markers = [];
  List<Point> positions = [];

  Point? myLocation;
  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  List<SuggestItem> suggestions = [];

  void onMapCreated(YandexMapController controller) {
    mapController = controller;

    setState(() {});
  }

  void getSearchSuggestions(String address) async {
    mapController.toggleUserLayer(visible: true);
    suggestions = await YandexMapService.getSearchSuggestions(address);
    setState(() {});
  }

  void goToLocation(Point? location) {
    if (location != null) {
      mapController.moveCamera(
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
        ),
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location,
            zoom: 15,
          ),
        ),
      );
    }
  }

  void onCameraPositionChanged(
    CameraPosition position,
    CameraUpdateReason reason,
    bool finish,
  ) {
    myLocation = position.target;
    setState(() {});
  }

  void addMarker() async {
    if (markers.isEmpty) {
      markers.add(
        PlacemarkMapObject(
          mapId: MapObjectId(UniqueKey().toString()),
          point: myLocation!,
          opacity: 1,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                "assets/placemark.png",
              ),
              scale: 0.5,
            ),
          ),
        ),
      );
    }

    setState(() {});
  }

  void makeRestaurant() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      label: Text("Restarant nomini kiriting!"),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final controller = RestaurantsController();
                    final address =
                        await YandexMapService.searchPlace(myLocation!);
                    controller.restaurants.add(
                      Restaurant(
                        name: nameController.text,
                        image: "assets/restaurant.png",
                        phone: "+998 90 123 45 67",
                        location: myLocation!,
                        address: address,
                      ),
                    );
                    Navigator.pushReplacement(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (ctx) {
                          print(controller.restaurants);
                          return RestaurantsScreen();
                        },
                      ),
                    );
                  },
                  child: Text("Restaran qo'shish"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onCameraPositionChanged: onCameraPositionChanged,
            onMapCreated: onMapCreated,
            mapObjects: [
              ...markers,
            ],
          ),
          const Align(
            child: Icon(
              Icons.place,
              size: 50,
              color: Colors.blue,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: const Alignment(0, -0.8),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: searchContoller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: getSearchSuggestions,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight:
                            (70 * suggestions.length).clamp(0, 300).toDouble(),
                      ),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ListView.builder(
                        itemCount: suggestions.length,
                        itemBuilder: (ctx, index) {
                          final suggestion = suggestions[index];
                          return ListTile(
                            onTap: () {
                              goToLocation(suggestion.center);
                            },
                            title: Text(suggestion.displayText),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 200,
          ),
          FloatingActionButton(
            onPressed: () {
              addMarker();
            },
            child: const Icon(
              Icons.restaurant,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              makeRestaurant();
            },
            child: const Icon(
              Icons.add,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              goToLocation(najotTalim);
            },
            child: const Icon(
              Icons.location_on_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
