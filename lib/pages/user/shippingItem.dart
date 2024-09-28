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

class ShippingItemPage extends StatefulWidget {
  const ShippingItemPage({super.key});

  @override
  State<ShippingItemPage> createState() => _ShippingItemPageState();
}

class _ShippingItemPageState extends State<ShippingItemPage> {
  late Future<void> loadData;
  List<Map<String, dynamic>> shippingList = []; // ลิสต์สำหรับเก็บรายการค้นหา
  UserProfile userProfile = UserProfile();
  var db = FirebaseFirestore.instance;
  late StreamSubscription listener;
  var dataShipping;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
    userProfile = context.read<Appdata>().user;
    final docRef =
        db.collection("order").where("uidShipping", isEqualTo: userProfile.id);
    listener = docRef.snapshots().listen(
      (event) async {
        if (event.docs.isNotEmpty) {
          shippingList.clear(); // เคลียร์ list ก่อนเริ่มเพิ่มใหม่
          for (var shipping in event.docs) {
            var userShippingDoc = db.collection("user");

            var query =
                userShippingDoc.where("id", isEqualTo: shipping['uidReceive']);
            var result = await query.get();

            if (result.docs.isNotEmpty) {
              for (var doc in result.docs) {
                shippingList.add(doc.data());
              }
            } else {
              log("ไม่มี user คนนี้แล้ว");
            }
          }
          log(shippingList.toString()); // log ข้อมูล shippingList
        } else {
          log('No documents found');
        }
        setState(() {});
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(height: Get.height / 4),
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
          } else if (shippingList.isEmpty) {
            return Column(
              children: [
                SizedBox(height: Get.height / 4),
                Center(
                  child: FaIcon(
                    FontAwesomeIcons.boxesPacking,
                    size: Get.height / 10,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Get.textTheme.headlineSmall!.fontSize!,
                  ),
                  child: Center(
                    child: Text(
                      'ไม่มีรายการสินค้าที่จัดส่ง',
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
                  children: shippingList
                      .map((shipping) => buildProfileCard(shipping['image'],
                          shipping['name'], shipping['phone'], "กำลังส่ง"))
                      .toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    setState(() {});
  }

  Widget buildProfileCard(
      String image, String name, String phoneNumber, String status) {
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
}
