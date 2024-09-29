
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class Appdata with ChangeNotifier {
  String userStatus = '';
  String page = '';
  LatLng latLng = const LatLng(0, 0);
  late UserProfile user;
  late ForgotPassword forgotUser;
  late ShippingItem shipping;
  StreamSubscription? listener;
}

class UserProfile {
  int id = 0;
}

class ForgotPassword {
  int id = 0;
  String type = '';
  String phone = '';
}

class ShippingItem {
  int id = 0;
}

void dialogLoad(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // ปิดการทำงานของการกดนอก dialog เพื่อปิด
    builder: (BuildContext context) {
      return const Dialog(
        backgroundColor: Colors.transparent, // พื้นหลังโปร่งใส
        child: Center(
          child:
              CircularProgressIndicator(), // แสดงแค่ CircularProgressIndicator
        ),
      );
    },
  );
}

void showErrorDialog(String title, String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: Get.textTheme.headlineMedium!.fontSize,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFE53935),
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: Get.textTheme.titleLarge!.fontSize,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFF7622),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFFE53935)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            )),
          ),
          child: Text(
            'ปิด',
            style: TextStyle(
              fontSize: Get.textTheme.titleLarge!.fontSize,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ],
    ),
  );
}
