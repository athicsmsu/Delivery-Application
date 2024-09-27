import 'dart:developer';

import 'package:delivery_application/pages/rider/detailRider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MainRiderPage extends StatefulWidget {
  const MainRiderPage({super.key});

  @override
  State<MainRiderPage> createState() => _MainRiderPageState();
}

class _MainRiderPageState extends State<MainRiderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipRect(
            child: Align(
              heightFactor: 0.8,
              child: Image.asset(
                'assets/images/RiderHome.jpg',
                width: double.infinity,
              ),
            ),
          ),
          // Container ที่เป็นวงกลมสีเหลืองทับอยู่บนรูป
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity, // ความกว้างของ Container
              height: 600, // ความสูงของ Container
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5), // สีของ Container
                borderRadius:
                    BorderRadius.vertical(top: Radius.elliptical(200, 50)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Container(
                        width: 400, // กำหนดความกว้างของ Container
                        height: 150, // กำหนดความสูงของ Container
                        decoration: BoxDecoration(
                          color: Colors.white, // สีพื้นหลังของ Container
                          border: Border.all(
                              color: Colors.black, width: 2), // ขอบสีดำ
                          borderRadius: BorderRadius.circular(20), // โค้งขอบ
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/RiderHome.jpg',
                                width: 100, // กำหนดความกว้างของรูป
                                height: 100, // กำหนดความสูงของรูป
                                fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Username",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  Text("080-xxx-xxxx",
                                      style: TextStyle(color: Colors.blueGrey)),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton(
                                    onPressed: () {
                                      log('รับออร์เดอร์');
                                      Get.to(() => const detailRiderPage());
                                    },
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          Size(
                                              Get.textTheme.titleLarge!
                                                      .fontSize! *
                                                  2,
                                              Get.textTheme.titleMedium!
                                                      .fontSize! *
                                                  2)), // กำหนดขนาดของปุ่ม
                                      backgroundColor:
                                          MaterialStateProperty.all(const Color(
                                              0xFF56DA40)), // สีพื้นหลังของปุ่ม
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            24.0), // ทำให้ขอบมน
                                      )),
                                    ),
                                    child: Text('รับออร์เดอร์',
                                        style: TextStyle(
                                          fontSize: Get
                                              .textTheme.titleSmall!.fontSize,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFFFFFF),
                                        ))),
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
