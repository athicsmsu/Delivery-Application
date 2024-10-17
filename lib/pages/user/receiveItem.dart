import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/user/checkStatusOrder.dart';
import 'package:delivery_application/pages/user/mapAllList.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReceiveItemPage extends StatefulWidget {
  const ReceiveItemPage({super.key});

  @override
  State<ReceiveItemPage> createState() => _ReceiveItemPageState();
}

class _ReceiveItemPageState extends State<ReceiveItemPage> {
  late Future<void> loadData;
  List<Map<String, dynamic>> receiveList = []; // ลิสต์สำหรับเก็บรายการค้นหา
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
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.textTheme.titleMedium!.fontSize!),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilledButton(
                    onPressed: () {
                      Get.to(() => const MapAllList());
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size(
                          Get.width / 2.5,
                          Get.textTheme.titleMedium!.fontSize! *
                              3)), // กำหนดขนาดของปุ่ม
                      backgroundColor: WidgetStateProperty.all(
                          const Color(0xFFE53935)), // สีพื้นหลังของปุ่ม
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // ทำให้ขอบมน
                      )),
                    ),
                    child: Text('ดูรายการทั้งหมดบนแผนที่',
                        style: TextStyle(
                          fontSize: Get.textTheme.titleSmall!.fontSize,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
                        ))),
              ],
            ),
          ),
          FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    SizedBox(height: Get.height / 2.5),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 10),
                      Text(
                        'เกิดข้อผิดพลาดในการโหลดข้อมูล',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: Get.textTheme.headlineSmall!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (statusLoad == "Loading") {
                return Column(
                  children: [
                    SizedBox(height: Get.height / 2.5),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              } else if (receiveList.isEmpty) {
                return Column(
                  children: [
                    SizedBox(height: Get.height / 4),
                    Center(
                      child: FaIcon(
                        FontAwesomeIcons.boxArchive,
                        size: Get.height / 10,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Get.textTheme.headlineSmall!.fontSize!,
                      ),
                      child: Center(
                        child: Text(
                          'ไม่มีรายการสินค้าที่ได้รับ',
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
                      children: receiveList.map((shipping) {
                        var userData = shipping['userData']; // ดึงข้อมูล userData
                        var orderData =
                            shipping['orderData']; // ดึงข้อมูล orderData
                        return buildProfileCard(
                            userData['image'],
                            userData['name'] ?? 'ไม่ระบุชื่อ', // ตรวจสอบ null
                            userData['phone'] ?? 'ไม่ระบุเบอร์โทร', // ตรวจสอบ null
                            orderData['status'],orderData['oid']);
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> loadDataAsync() async {
    userProfile = context.read<Appdata>().user;
    final docRef =
        db.collection("order").where("uidReceive", isEqualTo: userProfile.id);

    // ยกเลิก listener ก่อนหน้า
    if (context.read<Appdata>().listener != null) {
      context.read<Appdata>().listener!.cancel();
      context.read<Appdata>().listener = null;
    }

    context.read<Appdata>().listener = docRef.snapshots().listen(
      (orderSnapshot) async {
        if (orderSnapshot.docs.isNotEmpty) {
          receiveList.clear(); // เคลียร์ list ก่อนเริ่มเพิ่มใหม่
          var receiveDocs = orderSnapshot.docs.toList();

          // ดึง uidShipping จาก order ทั้งหมดที่ได้มา
          var uidShippingList =
              receiveDocs.map((doc) => doc['uidShipping']).toList();

          // ยกเลิก listener2 ก่อนหน้า
          if (context.read<Appdata>().listener2 != null) {
            context.read<Appdata>().listener2!.cancel();
            context.read<Appdata>().listener2 = null;
          }

          // ใช้ in query เพื่อดึงข้อมูล user ที่มี id ตรงกับ uidReceive
          var userQuery =
              db.collection("user").where("id", whereIn: uidShippingList);
          context.read<Appdata>().listener2 = userQuery.snapshots().listen(
            (userSnapshot) {
              if (userSnapshot.docs.isNotEmpty) {
                receiveList.clear(); // ล้างรายการก่อนเพิ่มข้อมูลใหม่

                // สร้างแผนที่เพื่อจับคู่ user id กับข้อมูลผู้ใช้
                var userMap = {
                  for (var userDoc in userSnapshot.docs)
                    userDoc['id']: userDoc.data()
                };

                // ลูปผ่าน order แต่ละรายการ และผูกข้อมูล user
                for (var orderDoc in receiveDocs) {
                  var uidShipping = orderDoc['uidShipping'];
                  var userData = userMap[
                      uidShipping]; // ดึงข้อมูลผู้ใช้ที่ตรงกับ uidShipping
                  if (userData != null) {
                    receiveList.add({
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
          receiveList = [];
          setState(() {}); // อัปเดต UI เมื่อไม่มีข้อมูล
        }
      },
      onError: (error) => log("Order listen failed: $error"),
    );
  }

  Widget buildProfileCard(
      String? image, String name, String phoneNumber, String status,int orderid) {
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
            SizedBox(
              width: Get.height / 7.5,
              child: Column(
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
            ),
            status == "ไรเดอร์นำส่งสินค้าแล้ว"
                ? FilledButton(
                    onPressed: () {
                      CheckStatusOrder check = CheckStatusOrder();
                      check.oid = orderid;
                      context.read<Appdata>().checkStatusOrder = check;
                       Get.to(() => const CheckStatusOrderUserPage());
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size(
                          Get.textTheme.titleLarge!.fontSize! * 2,
                          Get.textTheme.titleMedium!.fontSize! *
                              2)), // กำหนดขนาดของปุ่ม
                      backgroundColor: WidgetStateProperty.all(
                          const Color(0xFF56DA40)), // สีพื้นหลังของปุ่ม
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
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
                      CheckStatusOrder check = CheckStatusOrder();
                      check.oid = orderid;
                      context.read<Appdata>().checkStatusOrder = check;
                      Get.to(() => const CheckStatusOrderUserPage());
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size(
                          Get.textTheme.titleLarge!.fontSize! * 2,
                          Get.textTheme.titleMedium!.fontSize! *
                              2)), // กำหนดขนาดของปุ่ม
                      backgroundColor: WidgetStateProperty.all(
                          const Color(0xFFFF7622)), // สีพื้นหลังของปุ่ม
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
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
}
