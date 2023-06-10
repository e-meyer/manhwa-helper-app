import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manhwa_alert/helper_screen.dart';
import 'package:manhwa_alert/layers/scrape/view/screen/scrape_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

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
      home: HelperScreen(),
    );
  }
}
