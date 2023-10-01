import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/city_data.dart';

class FetchCityAPI {
  CityData? cityData;

  // procecssing the data from response -> to json
  Future<List> processCityData(dynamic cityName) async {
    var response =
        await http.get(Uri.parse('https://geocode.maps.co/search?q=$cityName'));
    final List<dynamic> data = jsonDecode(response.body);
    return data;
  }
}
