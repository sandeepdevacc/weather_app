import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/helper/authentication_helper.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String city = "";
  String date = DateFormat("yMMMMd").format(DateTime.now());

  final WeatherController globalController =
      Get.put(WeatherController(), permanent: true);

  @override
  void initState() {
    globalController.fetchCityName(globalController.getLattitude().value,
        globalController.getLongitude().value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => globalController.checkLoading().isTrue
          ? Container()
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        globalController.getCityName().value,
                        style: const TextStyle(fontSize: 35, height: 2),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        date,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[700], height: 1.5),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, right: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'search_city_screen');
                    },
                    child: Image.asset(
                      "assets/icons/search.png",
                      height: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 15),
                  child: InkWell(
                    onTap: () {
                      showLogoutDialog(context);
                    },
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Perform logout or any other action here.
                // Navigator.of(context).pop(); // Close the dialog.
                SharedPreferences prefs = await SharedPreferences.getInstance();

                AuthenticationHelper().signOut().then((result) {
                  if (result == null) {
                    prefs.clear();
                    Navigator.pushReplacementNamed(context, 'splash_screen');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        result,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ));
                  }
                });
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
