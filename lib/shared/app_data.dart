import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class Appdata with ChangeNotifier {
  String imageNetworkError = 'ssets/images/profile-picture.png';
  String imageDefaltUser = 'assets/images/profile-picture.png';
  String imageDefaltRider = 'assets/images/RegisterDemo.jpg';
  String imageUserBg = 'assets/images/UserBg.jpg';
  String imageRiderBg = 'assets/images/RiderHome.jpg';
  StreamSubscription? listener;
  StreamSubscription? listener2;
  String userStatus = '';
  String page = '';
  LatLng latLng = const LatLng(0, 0);
  late UserProfile user;
  late ShippingItem shipping;
  late ForgotPassword forgotUser;
}

class UserProfile {
  int id = 0;
}

class ShippingItem {
  int id = 0;
}

class ForgotPassword {
  int id = 0;
  String type = '';
}

void showLoadDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // ปิดการทำงานของการกดนอก dialog เพื่อปิด
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          log('กำลังโหลด');
        },
        child: const Dialog(
          backgroundColor: Colors.transparent, // พื้นหลังโปร่งใส
          child: Center(
            child:
                CircularProgressIndicator(), // แสดงแค่ CircularProgressIndicator
          ),
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

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // ทำให้มุมโค้งมน
      ),
      title: Text(
        'ออกจากระบบ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Get.textTheme.headlineMedium!.fontSize,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFE53935),
          // letterSpacing: 1
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Get.textTheme.titleLarge!.fontSize!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(Get.textTheme.displaySmall!.fontSize! * 3,
                      Get.textTheme.titleLarge!.fontSize! * 2.5),
                  backgroundColor: const Color(0xFFFF7622),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    fontSize: Get.textTheme.titleLarge!.fontSize,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFFFFF),
                    // letterSpacing: 1
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(Get.textTheme.displaySmall!.fontSize! * 3,
                      Get.textTheme.titleLarge!.fontSize! * 2.5),
                  backgroundColor: const Color(0xFFE53935),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(
                    fontSize: Get.textTheme.titleLarge!.fontSize,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFFFFF),
                    // letterSpacing: 1
                  ),
                ),
                onPressed: () {
                  if (context.read<Appdata>().listener != null) {
                    context.read<Appdata>().listener!.cancel();
                    context.read<Appdata>().listener = null;
                    log('Stop listener');
                  }
                  if (context.read<Appdata>().listener2 != null) {
                    context.read<Appdata>().listener2!.cancel();
                    context.read<Appdata>().listener2 = null;
                    log('Stop listener2');
                  }
                  context.read<Appdata>().userStatus = "logout";
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void showRegisterCompleteDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(
          'สำเร็จ',
          style: TextStyle(
            fontSize: Get.textTheme.headlineMedium!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE53935),
            // letterSpacing: 1
          ),
        ),
        content: Text(
          'สมัครสมาชิกสำเร็จ',
          style: TextStyle(
            fontSize: Get.textTheme.titleLarge!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF7622),
            // letterSpacing: 1
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              LatLng latLngDemo = const LatLng(0.0, 0.0);
              context.read<Appdata>().latLng = latLngDemo;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFFE53935)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
              )),
            ),
            child: Text(
              'ปิด',
              style: TextStyle(
                fontSize: Get.textTheme.titleLarge!.fontSize,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFFFFF),
                // letterSpacing: 1
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showSaveCompleteDialog(
    String title, String message, BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: Get.textTheme.headlineMedium!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE53935),
            // letterSpacing: 1
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: Get.textTheme.titleLarge!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF7622),
            // letterSpacing: 1
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (context.read<Appdata>().page == "Forgot") {
                context.read<Appdata>().page = "";
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (context.read<Appdata>().page == "Profile") {
                context.read<Appdata>().page = "";
                Navigator.of(context).pop();
              } else {
                context.read<Appdata>().page = "";
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFFE53935)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
              )),
            ),
            child: Text(
              'ปิด',
              style: TextStyle(
                fontSize: Get.textTheme.titleLarge!.fontSize,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFFFFF),
                // letterSpacing: 1
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showCompleteDialgAndBackPage(
    String title, String message, BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: Get.textTheme.headlineMedium!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE53935),
            // letterSpacing: 1
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: Get.textTheme.titleLarge!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF7622),
            // letterSpacing: 1
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFFE53935)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
              )),
            ),
            child: Text(
              'ปิด',
              style: TextStyle(
                fontSize: Get.textTheme.titleLarge!.fontSize,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFFFFF),
                // letterSpacing: 1
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
