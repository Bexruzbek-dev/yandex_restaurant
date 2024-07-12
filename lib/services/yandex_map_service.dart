import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapService {
  static Future<List<SuggestItem>> getSearchSuggestions(String address) async {
    final result = await YandexSuggest.getSuggestions(
      text: address,
      boundingBox: const BoundingBox(
        northEast: Point(
          latitude: 0,
          longitude: 0,
        ),
        southWest: Point(
          latitude: 0,
          longitude: 0,
        ),
      ),
      suggestOptions: const SuggestOptions(
        suggestType: SuggestType.geo,
      ),
    );

    final suggestionResult = await result.$2;

    if (suggestionResult.error != null) {
      print("Manzil topilmadi");
      return [];
    }

    return suggestionResult.items ?? [];
  }

  static Future<String> searchPlace(Point location) async {
    final result = await YandexSearch.searchByPoint(
      point: location,
      searchOptions: const SearchOptions(
        searchType: SearchType.geo,
      ),
    );

    final searchResult = await result.$2;

    if (searchResult.error != null) {
      print("Joylashuv nomini bilmadim");
      return "Joy topilmadi";
    }

    print(searchResult.items?.first.toponymMetadata?.address.formattedAddress);

    return searchResult.items!.first.name;
  }
}
