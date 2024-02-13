import 'package:flutter/material.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:movie_app/screens/splash_screen.dart';
import 'package:flutter_riverpod/src/framework.dart';

void main() {
  runApp(
    SplashScreen(
      key: UniqueKey(),
      onInitializationComplete: () => runApp(
        ProviderScope(
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext _context) => HomeScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
