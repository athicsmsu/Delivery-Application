import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/rider/detailRider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MainRiderPage extends StatefulWidget {
  const MainRiderPage({super.key});

  @override
  State<MainRiderPage> createState() => _MainRiderPageState();
}

class _MainRiderPageState extends State<MainRiderPage> {
  List<Map<String, dynamic>> orderList = [];
  List<Map<String, dynamic>> userList = [];
  var db = FirebaseFirestore.instance;

  late Future<void> loadData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData = loadDataAsync();
  }

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
                    FutureBuilder(
                      future: loadData, // ฟังก์ชันที่ดึงข้อมูลจากฐานข้อมูล
                      builder: (context, snapshot) {
                        // ตรวจสอบสถานะการโหลดข้อมูล
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              SizedBox(height: Get.height / 10),
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          );
                        }

                        // ถ้ามี error ให้แสดงข้อความ error
                        else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(height: Get.height / 10),
                                Text(
                                  'เกิดข้อผิดพลาดในการโหลดข้อมูล',
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize:
                                        Get.textTheme.headlineSmall!.fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // ตรวจสอบว่ามีข้อมูลหรือไม่
                        else if (orderList.isEmpty) {
                          return Column(
                            children: [

                              SizedBox(height: Get.height / 5),
                                  Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.boxOpen,
                                      size: Get.height / 10,
                                    ),
                                  ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                          vertical: Get
                                              .textTheme.headlineSmall!.fontSize!,
                                        ),
                                child: Center(
                                  child: Text(
                                    'ยังไม่มีออร์เดอร์',
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontSize: Get.textTheme.headlineSmall!.fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(top: Get.textTheme.labelSmall!.fontSize!),
                child: Column(
                  children: orderList.map((order) {
                    return buildProfileCard();
                  }).toList(),
                ),
              ),
            );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> loadDataAsync() async {
    orderList = [];
    userList = [];
     //var query  = db.collection("user");
      var orderResult = await db.collection("order").get();
      var userResult = await db.collection("user").get();

    // ตรวจสอบว่ามีผลลัพธ์หรือไม่
    if (orderResult.docs.isNotEmpty) {
      for (var doc in orderResult.docs) {
        orderList.add(doc
            .data()); 
      }
    } 
    if (userResult.docs.isNotEmpty) {
      for (var doc in userResult.docs) {
        userList.add(doc
            .data()); 
      }
    } 

    setState(() {});
  }
}
  @override
  Widget buildProfileCard() {
    return Container(
      width: 400, // กำหนดความกว้างของ Container
      height: 150, // กำหนดความสูงของ Container
      decoration: BoxDecoration(
        color: Colors.white, // สีพื้นหลังของ Container
        border: Border.all(
            color: Colors.black, width: 2), // ขอบสีดำ
        borderRadius:
            BorderRadius.circular(20), // โค้งขอบ
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
            padding: EdgeInsets.only(
                top: 30), // กำหนดช่องว่างด้านบน
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // จัดข้อความไปทางซ้าย
              children: [
                Text(
                  "Username",
                  style: TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20), // เว้นระยะห่าง
                Text(
                  "080-xxx-xxxx",
                  style:
                      TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment
                .end, // จัดปุ่มไว้ที่ด้านล่างสุด
            children: [
              FilledButton(
                onPressed: () {
                  Get.to(() =>
                      const detailRiderPage()); // เมื่อกดปุ่ม จะไปยังหน้ารายละเอียด
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(
                      Get.textTheme.titleLarge!
                              .fontSize! *
                          2,
                      Get.textTheme.titleMedium!
                              .fontSize! *
                          2,
                    ), // กำหนดขนาดของปุ่ม
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(
                    const Color(
                        0xFF56DA40), // สีพื้นหลังของปุ่ม
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          24.0), // ทำให้ขอบมน
                    ),
                  ),
                ),
                child: Text(
                  'รับออร์เดอร์',
                  style: TextStyle(
                    fontSize: Get
                        .textTheme.titleSmall!.fontSize,
                    fontFamily:
                        GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: const Color(
                        0xFFFFFFFF), // สีตัวอักษรขาว
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  
}
