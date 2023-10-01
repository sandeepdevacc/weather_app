import 'package:get/get.dart';
import 'package:weather_app/api/fetch_city.dart';

class CityController extends GetxController {
  final RxBool _isLoading = true.obs;

  // instance for them to be called
  RxBool checkLoading() => _isLoading;

  final cityData = [].obs;

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getCity([]);
    }
    super.onInit();
  }

  getCity([cityName]) async {
    return await FetchCityAPI().processCityData(cityName).then((value) {
      cityData.value = value.cast<Map<String, dynamic>>();
      _isLoading.value = false;
    });
  }
}
