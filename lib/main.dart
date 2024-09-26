import 'package:delivery_application/pages/login.dart';
import 'package:delivery_application/pages/rider/detelRider.dart';
import 'package:delivery_application/pages/rider/homeRider.dart';
import 'package:delivery_application/pages/rider/mapRider.dart';
import 'package:delivery_application/pages/rider/settingRider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Delivery Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const mapRiderPage(),
    );
  }
}