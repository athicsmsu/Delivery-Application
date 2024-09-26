import 'package:delivery_application/pages/login.dart';
import 'package:delivery_application/pages/user/detailUser.dart';
import 'package:delivery_application/pages/user/mainUser.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async{
  await GetStorage.init();
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => Appdata(),
      )
    ],
    child: const MyApp(),
  ));
  
  // runApp(const MyApp());
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
      home: const detailUserPage(),
    );
  }
}