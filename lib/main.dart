import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trendtrack/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:214373474010:android:a50d803157633ae3c94fe3',
      apiKey: 'AIzaSyDMRmhsfHOxyJ-P2RpvtD90wrVdKXp_EXI',
      messagingSenderId: '214373474010',
      projectId: 'trendtrack-28fbc',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
