
import 'package:edtech/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBxZS-H-oMoPuXe0jHCP8Woa8PoelXZqEY",
            authDomain: "edtech-c3143.firebaseapp.com",
            projectId: "edtech-c3143",
            storageBucket: "edtech-c3143.appspot.com",
            messagingSenderId: "336424170699",
            appId: "1:336424170699:web:56357bdc6890b474bf174e",
            measurementId: "G-EFDLRQP7BH"));
  } else {
    await Firebase.initializeApp(
        // ignore: prefer_const_constructors
        options: FirebaseOptions(
            apiKey: 'AIzaSyASHGccyNpx-Kej4E8-LLMQMeC1l3E5xFU',
            projectId: 'edtech-c3143',
            //   storageBucket: "eshop-2dec0.appspot.com",
            messagingSenderId: '336424170699',
            appId: '1:336424170699:android:7854e09fb646febbbf174e'));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
