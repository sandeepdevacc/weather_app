import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/api/fetch_weather.dart';
import 'package:weather_app/model/weather_data.dart';

class WeatherController extends GetxController {
  // create various variables
  final RxBool _isLoading = true.obs;
  RxDouble lattitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  RxString getCity = "".obs;

  // instance for them to be called
  RxBool checkLoading() => _isLoading;
  RxDouble getLattitude() => lattitude;
  RxDouble getLongitude() => longitude;
  RxString getCityName() => getCity;

  final weatherData = WeatherData().obs;

  WeatherData getData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    } else {
      getIndex();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    // return if service is not enabled
    if (!isServiceEnabled) {
      return Future.error("Location not enabled");
    }

    // status of permission
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permission are denied forever");
    } else if (locationPermission == LocationPermission.denied) {
      // request permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location permission is denied");
      }
    }

    // getting the currentposition
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      // update our lattitude and longitude
      lattitude.value = value.latitude;
      longitude.value = value.longitude;
      // calling our weather api
      fetchWeatherData(value.latitude, value.longitude);
    });
  }

  fetchWeatherData(lat, lon) {
    return FetchWeatherAPI().processData(lat, lon).then((value) {
      weatherData.value = value;
      _isLoading.value = false;
    });
  }

  fetchCityName(lat, lon) async {
    try {
      return await placemarkFromCoordinates(lat, lon).then((value) {
        getCity.value = value[0].locality!;
        _isLoading.value = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print("getAddress catch ${e.toString()}");
      }
    }
  }

  RxInt getIndex() {
    return _currentIndex;
  }
}
