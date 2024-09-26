import 'dart:developer';

import 'package:delivery_application/pages/rider/mapRider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class detailRiderPage extends StatefulWidget {
  const detailRiderPage({super.key});

  @override
  State<detailRiderPage> createState() => _DetailRiderPageState();
}

class _DetailRiderPageState extends State<detailRiderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // กำหนดให้มุมโค้ง
              child: Image.asset(
                'assets/images/RiderHome.jpg',
                width: 350, // กำหนดความกว้าง
                height: 200, // กำหนดความสูง
                fit: BoxFit.cover, // ปรับขนาดให้เต็มพื้นที่
              ),
            ),
            Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของ Container
                border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                borderRadius: BorderRadius.circular(20), // โค้งขอบ
              ),
              child: Text(""),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("รายละเอียดสินค้า"),
                Container(
                  width: 350,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white, // สีพื้นหลังของ Container
                    border:
                        Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                    borderRadius: BorderRadius.circular(20), // โค้งขอบ
                  ),
                  child: Text(""),
                ),
              ],
            ),
            FilledButton(
                onPressed: () {
                  log('ถัดไป');
                  Get.to(() => const mapRiderPage());
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFE53935)),
                  minimumSize: MaterialStateProperty.all(Size(400, 50)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                  )),
                ),
                child: Text("ถัดไป",
                    style: TextStyle(
                      fontSize: Get.textTheme.titleSmall!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF),
                    )))
          ],
        ),
      ),
    );
  }
}
