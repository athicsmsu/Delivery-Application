import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

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
  late Future<void> loadData;
  OrderID orderid = OrderID();
  UserProfile userProfile = UserProfile();
  var db = FirebaseFirestore.instance;
  StreamSubscription? listener;
  String? userName;
  String? userPhone;
  String? imageUrl;
  String? detail;
  var distanceText;
  var shippingCost;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderid = context.read<Appdata>().order;
    userProfile = context.read<Appdata>().user;
    log(orderid.oid.toString());
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        log('กลับไปหน้าที่แล้วไม่ได้ถ้าไม่เสร็จงาน');
      },
      child: Scaffold(
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
                          Text(userName != null ? userName! : '...',
                              style: TextStyle(
                                fontSize: Get.textTheme.titleMedium!.fontSize,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: const Color(0xFF000000),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(userPhone != null ? userPhone! : '...',
                              style: TextStyle(
                                fontSize: Get.textTheme.titleMedium!.fontSize,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: const Color(0xFF000000),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(distanceText != null ? distanceText! : '...',
                              style: TextStyle(
                                fontSize: Get.textTheme.titleMedium!.fontSize,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: const Color(0xFF000000),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            (shippingCost?.toString() ?? "...") +
                                " บาท", // ตรวจสอบค่า null, ถ้าเป็น null ให้แสดง "0"
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: const Color(0xFF000000),
                            ),
                          ),
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
                    Get.to(() => const mapRiderPage());
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFE53935)),
                    minimumSize: MaterialStateProperty.all(Size(Get.width * 5,
                        Get.textTheme.displaySmall!.fontSize! * 1.8)),
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
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var uidReceive;
    var uidShipping;
    var latitudeRecivce;
    var longitudeRecivce;
    var latitudeShipping;
    var longitudeShipping;
    
    var result = await db
        .collection("order")
        .where('oid', isEqualTo: orderid.oid) // กรองตาม uidReceive
        .get();
    var orderData = result.docs.toList();
    orderData.map((orderMap) {
      detail = orderMap['detail'];
      imageUrl = orderMap['image'];
      uidReceive = orderMap['uidReceive'];
      uidShipping = orderMap['uidShipping'];
    }).toList();

    var userRecivce = await db
        .collection("user")
        .where('id', isEqualTo: uidReceive) // กรองตาม uidReceive
        .get();

    var userDataRecivce = userRecivce.docs.toList();
    userDataRecivce.map((userMap) {
      userName = userMap['name'];
      userPhone = userMap['phone'];
      var latLngRecivce = userMap['latLng'];
      latitudeRecivce = latLngRecivce['latitude'] ?? 0.0;
      longitudeRecivce = latLngRecivce['longitude'] ?? 0.0;
    }).toList();

    var userShipping = await db
        .collection("user")
        .where('id', isEqualTo: uidShipping) // กรองตาม uidReceive
        .get();

    var userDataShipping = userShipping.docs.toList();
    userDataShipping.map((userMap) {
      userName = userMap['name'];
      userPhone = userMap['phone'];
      var latLngShipping = userMap['latLng'];
      latitudeShipping = latLngShipping['latitude'] ?? 0.0;
      longitudeShipping = latLngShipping['longitude'] ?? 0.0;
    }).toList();

    // คำนวณระยะทางเป็นกิโลเมตร
    var distanceInKm = calculateDistance(
        latitudeRecivce, longitudeRecivce, latitudeShipping, longitudeShipping);

    // คำนวณระยะทางเป็นไมล์
    var distanceInMiles = distanceInKm * 0.621371;

    // ตรวจสอบระยะทาง

    if (distanceInKm >= 9999) {
      // ถ้าระยะทางถึง 9999 กิโลเมตร
      distanceText = "${distanceInMiles.toStringAsFixed(2)}  ไมล์";
    } else if (distanceInKm < 1) {
      // ถ้าระยะทางน้อยกว่า 1 กิโลเมตร แสดงเป็นเมตร
      var distanceInMeters =
          (distanceInKm * 1000).toInt(); // แปลงเป็นเมตรและทำให้เป็นจำนวนเต็ม
      distanceText = "$distanceInMeters  เมตร";
    } else {
      distanceText = "${distanceInKm.toStringAsFixed(2)}  กิโลเมตร";
    }
    // คำนวณค่าจัดส่ง: 1 กิโลเมตร = 10 บาท
    shippingCost = calculateShippingCost(distanceInKm);

    setState(() {
      // ทำการอัปเดตหน้าจอเมื่อดึงข้อมูลเสร็จ
    });
  }

  // ฟังก์ชันคำนวณค่าจัดส่งตามระยะทาง
  int calculateShippingCost(double distanceInKm) {
    if (distanceInKm < 1) {
      return 8; // ถ้าน้อยกว่า 1 กิโลเมตร คิดค่าจัดส่ง 8 บาท
    } else {
      return (distanceInKm * 10).round();
    }
  }

// ฟังก์ชันคำนวณระยะทางระหว่างพิกัดสองตำแหน่ง
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // รัศมีของโลกในหน่วยกิโลเมตร

    var dLat = _degToRad(lat2 - lat1);
    var dLon = _degToRad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    var distance = R * c; // ระยะทางในหน่วยกิโลเมตร

    return distance;
  }

// ฟังก์ชันแปลงองศาเป็นเรเดียน
  double _degToRad(double deg) {
    return deg * (math.pi / 180);
  }
}
