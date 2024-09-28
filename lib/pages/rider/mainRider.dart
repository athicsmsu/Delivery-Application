import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/user/mapUser.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainRiderPage extends StatefulWidget {
  const MainRiderPage({super.key});

  @override
  State<MainRiderPage> createState() => _MainRiderPageState();
}

class _MainRiderPageState extends State<MainRiderPage> {
  late Future<void> loadData;
  List<Map<String, dynamic>> shippingList = []; // ลิสต์สำหรับเก็บรายการค้นหา
  UserProfile userProfile = UserProfile();
  var db = FirebaseFirestore.instance;
  StreamSubscription? listener2;
  var dataShipping;
  var statusLoad = "Loading";

  @override
  void initState() {
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
                        else if (shippingList.isEmpty) {
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
                                  vertical:
                                      Get.textTheme.headlineSmall!.fontSize!,
                                ),
                                child: Center(
                                  child: Text(
                                    'ยังไม่มีออร์เดอร์',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize:
                                          Get.textTheme.headlineSmall!.fontSize,
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
                              padding: EdgeInsets.only(
                                  top: Get.textTheme.labelSmall!.fontSize!),
                              child: Column(
                                children: shippingList.map((shipping) {
                                  var userData = shipping[
                                      'userData']; // ดึงข้อมูล userData
                                  var orderData = shipping[
                                      'orderData']; // ดึงข้อมูล userData
                                  return buildProfileCard(
                                      userData['image'],
                                      userData['name'] ??
                                          'ไม่ระบุชื่อ', // ตรวจสอบ null
                                      userData['phone'] ??
                                          'ไม่ระบุเบอร์โทร', // ตรวจสอบ null
                                      orderData['status']);
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
    userProfile = context.read<Appdata>().user;
    final docRef =
        db.collection("order").where("status", isEqualTo: "รอไรเดอร์มารับสินค้า");

    // ยกเลิก listener ก่อนหน้า
    if (context.read<Appdata>().listener != null) {
      context.read<Appdata>().listener!.cancel();
      context.read<Appdata>().listener = null;
    }

    context.read<Appdata>().listener = docRef.snapshots().listen(
      (orderSnapshot) async {
        if (orderSnapshot.docs.isNotEmpty) {
          shippingList.clear(); // เคลียร์ list ก่อนเริ่มเพิ่มใหม่
          var shippingDocs = orderSnapshot.docs.toList();

          // ดึง uidReceive จาก order ทั้งหมดที่ได้มา
          var uidReceiveList =
              shippingDocs.map((doc) => doc['uidReceive']).toList();

          // ยกเลิก listener2 ก่อนหน้า
          if (listener2 != null) {
            listener2!.cancel();
            listener2 = null;
          }

          // ใช้ in query เพื่อดึงข้อมูล user ที่มี id ตรงกับ uidReceive
          var userQuery =
              db.collection("user").where("id", whereIn: uidReceiveList);
          listener2 = userQuery.snapshots().listen(
            (userSnapshot) {
              if (userSnapshot.docs.isNotEmpty) {
                shippingList.clear(); // ล้างรายการก่อนเพิ่มข้อมูลใหม่

                // สร้างแผนที่เพื่อจับคู่ user id กับข้อมูลผู้ใช้
                var userMap = {
                  for (var userDoc in userSnapshot.docs)
                    userDoc['id']: userDoc.data()
                };

                // ลูปผ่าน order แต่ละรายการ และผูกข้อมูล user
                for (var orderDoc in shippingDocs) {
                  var uidReceive = orderDoc['uidReceive'];
                  var userData = userMap[
                      uidReceive]; // ดึงข้อมูลผู้ใช้ที่ตรงกับ uidReceive
                  if (userData != null) {
                    shippingList.add({
                      'orderData': orderDoc.data(), // ข้อมูลจาก order
                      'userData': userData, // ข้อมูลจาก user
                    });
                  }
                }
                statusLoad = "โหลดเสร็จสิ้น";
              } else {
                statusLoad = "โหลดเสร็จสิ้น";
                log("ไม่พบข้อมูลผู้ใช้");
              }

              setState(() {}); // อัปเดต UI
            },
            onError: (error) => log("User listen failed: $error"),
          );
        } else {
          statusLoad = "โหลดเสร็จสิ้น";
          shippingList = [];
          log('No documents found in order');
          setState(() {}); // อัปเดต UI เมื่อไม่มีข้อมูล
        }
      },
      onError: (error) => log("Order listen failed: $error"),
    );
  }

  Widget buildProfileCard(
      String? image, String name, String phoneNumber, String status) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.textTheme.titleMedium!.fontSize!,
          vertical: Get.textTheme.labelSmall!.fontSize!),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Get.textTheme.titleMedium!.fontSize!,
            horizontal: Get.textTheme.titleMedium!.fontSize!),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          // border: Border.all(
          //     color: const Color.fromARGB(127, 153, 153, 153), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: (image != null)
                  ? Image.network(
                      image,
                      width: Get.height / 9,
                      height: Get.height / 9,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/UserProfile.jpg',
                      width: Get.height / 9,
                      height: Get.height / 9,
                      fit: BoxFit.cover,
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                    )),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(phoneNumber,
                        style: TextStyle(
                          fontSize: Get.textTheme.titleSmall!.fontSize,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF747783),
                        )),
                  ],
                ),
              ],
            ),
            status == "ส่งสำเร็จ"
                ? FilledButton(
                    onPressed: () {
                      log('สำเร็จ');
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(
                          Get.textTheme.titleLarge!.fontSize! * 2,
                          Get.textTheme.titleMedium!.fontSize! *
                              2)), // กำหนดขนาดของปุ่ม
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF56DA40)), // สีพื้นหลังของปุ่ม
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // ทำให้ขอบมน
                      )),
                    ),
                    child: Text('ส่งสำเร็จ',
                        style: TextStyle(
                          fontSize: Get.textTheme.titleSmall!.fontSize,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
                        )))
                : FilledButton(
                    onPressed: () {
                      Get.to(() => const mapUserPage());
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(
                          Get.textTheme.titleLarge!.fontSize! * 2,
                          Get.textTheme.titleMedium!.fontSize! *
                              2)), // กำหนดขนาดของปุ่ม
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xFFFF7622)), // สีพื้นหลังของปุ่ม
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // ทำให้ขอบมน
                      )),
                    ),
                    child: Text('กำลังส่ง',
                        style: TextStyle(
                          fontSize: Get.textTheme.titleSmall!.fontSize,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
                        ))),
          ],
        ),
      ),
    );
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
}
