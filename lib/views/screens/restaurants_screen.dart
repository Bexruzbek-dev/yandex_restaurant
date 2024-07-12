import 'package:dars75_yandexmap_restaurant/controllers/restaurants_controller.dart';
import 'package:dars75_yandexmap_restaurant/services/yandex_map_service.dart';
import 'package:dars75_yandexmap_restaurant/views/screens/map_screen.dart';
import 'package:dars75_yandexmap_restaurant/views/widgets/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final restaurantsController = RestaurantsController();

  Future<String> findLocation(Point location) async {
    final locationName = await YandexMapService.searchPlace(location);
    return locationName;
  }

  @override
  Widget build(BuildContext context) {
    int count = 4;

    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: restaurantsController.restaurants.length,
        itemBuilder: (ctx, index) {
          final restaurant = restaurantsController.restaurants[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) {
                    return MapScreen1(locatin: restaurant.location,res: restaurant,);
                  },
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: AssetImage(restaurant.image),
            ),
            title: Text(restaurant.name),
            subtitle: Text(restaurant.address),
            trailing: Text(
              "${count++} ⭐",
              style: TextStyle(fontSize: 18),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) {
                return MapScreen();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
