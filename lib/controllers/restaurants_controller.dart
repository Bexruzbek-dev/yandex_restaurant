import 'package:dars75_yandexmap_restaurant/models/restaurant.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class RestaurantsController {
  static final RestaurantsController _instance =
      RestaurantsController._internal();

  RestaurantsController._internal();

  factory RestaurantsController() {
    return _instance;
  }

  // List of restaurants
  List<Restaurant> restaurants = [
    Restaurant(
      name: "Nomdor",
      image: "assets/restaurant.png",
      phone: "+998 91 123 45 67",
      location: Point(latitude: 41.203, longitude: 69.102),
      address: "9-mavze Chilonzor",
    ),
  ];

}
