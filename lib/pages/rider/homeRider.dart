import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/rider/detailRider.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class homeRiderPage extends StatefulWidget {
  const homeRiderPage({super.key});

  @override
  State<homeRiderPage> createState() => _homeRiderPageState();
}

class _homeRiderPageState extends State<homeRiderPage> {
  late Future<void> loadData;
  List<Map<String, dynamic>> shippingList = []; // ลิสต์สำหรับเก็บรายการค้นหา
  UserProfile userProfile = UserProfile();
  var db = FirebaseFirestore.instance;
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
                context.read<Appdata>().imageRiderBg,
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
                              SizedBox(height: Get.height / 5),
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
                                SizedBox(height: Get.height / 5),
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
                        } else if (statusLoad == "Loading") {
                          return Column(
                            children: [
                              SizedBox(height: Get.height / 5),
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ],
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
                                    'ยังไม่มีที่สามารถรับได้',
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
                                      'orderData'];

                                  return buildProfileCard(
                                      userData['id'],
                                      userData['image'],
                                      userData['name'] ??
                                          'ไม่ระบุชื่อ', // ตรวจสอบ null
                                      userData['phone'] ??
                                          'ไม่ระบุเบอร์โทร', // ตรวจสอบ null
                                      orderData['status'],
                                      orderData['oid'],);  
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
    final docRef = db
        .collection("order")
        .where("status", isEqualTo: "รอไรเดอร์มารับสินค้า");

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
          if (context.read<Appdata>().listener2 != null) {
            context.read<Appdata>().listener2!.cancel();
            context.read<Appdata>().listener2 = null;
          }

          // ใช้ in query เพื่อดึงข้อมูล user ที่มี id ตรงกับ uidReceive
          var userQuery =
              db.collection("user").where("id", whereIn: uidReceiveList);
          context.read<Appdata>().listener2 = userQuery.snapshots().listen(
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
      int id,String? image, String name, String phoneNumber, String status, int oid) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.textTheme.titleMedium!.fontSize!,
          vertical: Get.textTheme.labelSmall!.fontSize!),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Get.textTheme.titleMedium!.fontSize!,
            horizontal: Get.textTheme.titleMedium!.fontSize!),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
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
                      errorBuilder: (context, error, stackTrace) {
                        // ถ้าเกิดข้อผิดพลาดในการโหลดรูปจาก URL
                        return Image.asset(
                          context.read<Appdata>().imageNetworkError,
                          width: Get.height / 9,
                          height: Get.height / 9,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      context.read<Appdata>().imageDefaltUser,
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
            FilledButton(
                onPressed:  () async {
                  ShippingItem shippingId = ShippingItem();
                  shippingId.id = id;
                  context.read<Appdata>().shipping = shippingId;
                  updateOrderStatus(oid.toString());
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
                child: Text('รับออร์เดอร์',
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

  void updateOrderStatus(String? oid) async {
  // ตรวจสอบว่า oid ไม่เป็น null
  if (oid != null && oid.isNotEmpty) {
    try {
      // อัปเดตสถานะในเอกสารที่มี oid ตรงกัน (Document ID)
      await FirebaseFirestore.instance.collection("order").doc(oid).update({
        'status': 'รอไรเดอร์มารับสินค้า',
      });
      
      // นำไปยังหน้า detailRiderPage
      Get.to(() => const detailRiderPage());

      print("Status updated successfully!");
    } catch (e) {
      print('Error updating status: $e');
    }
  } else {
    // แจ้งเตือนกรณีที่ oid เป็น null หรือว่างเปล่า
    print('Error: Order ID (oid) is null or empty');
  }
}

}