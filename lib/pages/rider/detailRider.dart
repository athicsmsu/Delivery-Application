import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/rider/mapRider.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class detailRiderPage extends StatefulWidget {
  const detailRiderPage({super.key});

  @override
  State<detailRiderPage> createState() => _DetailRiderPageState();
}

class _DetailRiderPageState extends State<detailRiderPage> {
  List<Map<String, dynamic>> orderlist = [];
  late Future<void> loadData;
  ShippingItem shippingItem = ShippingItem();
  UserProfile userProfile = UserProfile();
  var db = FirebaseFirestore.instance;
  StreamSubscription? listener;
  var dataReceivce;
  String? userName;
  String? userPhone;
  String? imageUrl;
  String? detail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shippingItem = context.read<Appdata>().shipping;
    userProfile = context.read<Appdata>().user;
    loadData = loadDataAsync();
  }

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
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!, // ใส่ค่า URL ของรูปภาพ
                      width: Get.height / 4, // กำหนดความกว้าง
                      height: Get.height / 4, // กำหนดความสูง
                      fit: BoxFit.cover, // กำหนดให้ภาพครอบคลุมตามขนาดที่กำหนด
                    )
                  : CircularProgressIndicator(), // หากไม่มีภาพ แสดงข้อความ
            ),
            Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของ Container
                border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                borderRadius: BorderRadius.circular(20), // โค้งขอบ
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ชื่อผู้รับสินค้า",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF000000),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text("เบอร์โทร",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF000000),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text("ระยะทาง",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF000000),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text("ค่าจัดส่ง",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF000000),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName != null ? userName! : 'No Name',
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: const Color(0xFF000000),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(userPhone != null ? userPhone! : 'No Name',
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: const Color(0xFF000000),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text("3 km",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: const Color(0xFF000000),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text("30 บาท",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: const Color(0xFF000000),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("รายละเอียดสินค้า",
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: Get.textTheme.titleMedium!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF32343E))),
                Container(
                  width: 350,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white, // สีพื้นหลังของ Container
                    border:
                        Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                    borderRadius: BorderRadius.circular(20), // โค้งขอบ
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: detail != null
                        ? Text(detail!,
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: const Color(0xFF000000),
                            ))
                        : Text("...กำลังโหลด..."),
                  ),
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

  Future<void> loadDataAsync() async {
    orderlist = [];

    var userRecivce =
        await db.collection("user").doc(shippingItem.id.toString()).get();
    var userData = userRecivce.data();
    var userId = userData?['id'];
    userName = userData?['name'];
    userPhone = userData?['phone'];

    // ดึงข้อมูลเอกสารทั้งหมดจากคอลเลกชัน "order"
    var result = await db
        .collection("order")
        .where('uidReceive', isEqualTo: userId) // กรองตาม uidReceive
        .get();

    // วนลูปผ่านเอกสารทั้งหมดแล้วเพิ่มลงใน orderlist
    for (var doc in result.docs) {
      orderlist.add(doc.data()); // นำข้อมูลจากเอกสารมาใส่ใน orderlist
    }

    orderlist.forEach((order) {
      imageUrl = order['image'];
      detail = order['detail'];
    });

    setState(() {
      // ทำการอัปเดตหน้าจอเมื่อดึงข้อมูลเสร็จ
    });
  }
}
