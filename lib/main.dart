import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/scrape/view/screen/scrape_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Carousel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScrapeScreen(),
    );
  }
}
