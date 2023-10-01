import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/widgets/current_weather_widget.dart';
import 'package:weather_app/widgets/daily_data_forecast.dart';
import 'package:weather_app/widgets/header_widget.dart';
import 'package:weather_app/widgets/hourly_data_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // call
  final WeatherController globalController =
      Get.put(WeatherController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => globalController.checkLoading().isTrue
              // ? Center(
              //     child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Image.asset(
              //         "assets/icons/clouds.png",
              //         height: 200,
              //         width: 200,
              //       ),
              //       const CircularProgressIndicator()
              //     ],
              //   ))
              ? skeleton()
              : Center(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const HeaderWidget(),
                      // for our current temp ('current')
                      CurrentWeatherWidget(
                        weatherDataCurrent:
                            globalController.getData().getCurrentWeather(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      HourlyDataWidget(
                          weatherDataHourly:
                              globalController.getData().getHourlyWeather()),
                      DailyDataForecast(
                        weatherDataDaily:
                            globalController.getData().getDailyWeather(),
                      ),
                    ],
                  ),
                ),
        ),
        // child: skeleton(),
      ),
    );
  }

  Widget skeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        children: [
          Container(
            width: 20.0,
            height: 100.0, // Height of the shimmering box
            color: Colors.grey[300], // Color of the shimmering box
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 200.0,
            height: 16.0,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 150.0,
                height: 100.0,
                color: Colors.grey[300],
              ),
              Container(
                width: 150.0,
                height: 100.0,
                color: Colors.grey[300],
              )
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 80.0,
                height: 50.0,
                color: Colors.grey[300],
              ),
              Container(
                width: 80.0,
                height: 50.0,
                color: Colors.grey[300],
              ),
              Container(
                width: 80.0,
                height: 50.0,
                color: Colors.grey[300],
              )
            ],
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            height: 150,
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 5);
                },
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    width: 80.0,
                    height: 50.0,
                    color: Colors.grey[300],
                  );
                }),
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 400,
            color: Colors.grey[300],
          )
        ],
      ),
    );
  }
}
