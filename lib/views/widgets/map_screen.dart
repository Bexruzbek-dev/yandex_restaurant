import 'package:dars75_yandexmap_restaurant/controllers/restaurants_controller.dart';
import 'package:dars75_yandexmap_restaurant/models/restaurant.dart';
import 'package:dars75_yandexmap_restaurant/services/yandex_map_service.dart';
import 'package:dars75_yandexmap_restaurant/views/screens/restaurants_screen.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen1 extends StatefulWidget {
  Point locatin;
  Restaurant res;
  MapScreen1({super.key, required this.locatin, required this.res});

  @override
  State<MapScreen1> createState() => _MapScreen1State();
}

class _MapScreen1State extends State<MapScreen1> {
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
    goToLocation(widget.locatin);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.res.name,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.amber,
          ),
        ),
      ),
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
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 130,
                width: double.infinity,
                decoration:const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/restaurant.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1. The Palm  Los Angeles',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '240m',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.blue,
                                );
                              }),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '12 reviews',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Burgers • Italian • Hot vine • Grilled • Canadian',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
