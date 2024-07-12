import 'package:yandex_mapkit/yandex_mapkit.dart';

class Restaurant {
  String name;
  String image;
  String phone;
  Point location;
  String address;

  Restaurant({
    required this.name,
    required this.image,
    required this.phone,
    required this.location,
    required this.address,
  });
}
