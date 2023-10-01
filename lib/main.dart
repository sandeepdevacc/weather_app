import 'package:flutter/material.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/screens/login_screen.dart';
import 'package:weather_app/screens/search_city_screen.dart';
import 'package:weather_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade200),
        useMaterial3: true,
      ),
      initialRoute: 'splash_screen',
      routes: {
        'splash_screen': (BuildContext context) => const SplashScreen(),
        'home_screen': (BuildContext context) => const HomeScreen(),
        'login_screen': (BuildContext context) => const LoginScreen(),
        'search_city_screen': (BuildContext context) => const SearchCityScreen(),
      },
    );
  }
}
