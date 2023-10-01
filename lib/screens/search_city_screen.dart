import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controller/city_controller.dart';
import 'package:weather_app/controller/weather_controller.dart';

class SearchCityScreen extends StatefulWidget {
  const SearchCityScreen({super.key});

  @override
  State<SearchCityScreen> createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  final TextEditingController _cityController = TextEditingController();

  final CityController cityController =
      Get.put(CityController(), permanent: true);

  final WeatherController globalController =
      Get.put(WeatherController(), permanent: true);
  @override
  void dispose() {
    super.dispose();
    _cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.search, size: 25),
                      hintText: "Search city name ...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      cityController.getCity(_cityController.text);
                    },
                  ),
                ),
                const SizedBox(width: 5)
              ],
            ),
            Obx(
              () => cityController.cityData.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text("No City Found"),
                      ),
                    )
                  : Expanded(child: buildCityList(cityController.cityData)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCityList(List cityData) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider(height: 2);
      },
      shrinkWrap: true,
      itemCount: cityData.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // prefs.setString("currentLat", cityData[index]['lat']);
            // prefs.setString("currentLon", cityData[index]['lon']);
            if (mounted) {
              globalController.fetchWeatherData(
                  cityData[index]['lat'], cityData[index]['lon']);
              globalController.fetchCityName(
                  double.parse(cityData[index]['lat']),
                  double.parse(cityData[index]['lon']));
              Navigator.pop(context);
            }
          },
          leading: const Icon(
            Icons.place,
            color: Colors.blue,
          ),
          title: Text(
            cityData[index]['display_name'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
