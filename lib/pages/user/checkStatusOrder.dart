import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CheckStatusOrderUserPage extends StatefulWidget {
  const CheckStatusOrderUserPage({super.key});

  @override
  State<CheckStatusOrderUserPage> createState() =>
      _CheckStatusOrderUserPageState();
}

class _CheckStatusOrderUserPageState extends State<CheckStatusOrderUserPage> {
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  LatLng latLngRider = const LatLng(16.246825669508297, 103.25199289277295);
  MapController mapController = MapController();
  bool isLoading = true; // สถานะการโหลด
  CheckStatusOrder order = CheckStatusOrder();
  UserProfile userProfile = UserProfile();
  var db = FirebaseFirestore.instance;
  var orderDoc;
  var dataUser;
  var dataRider;
  StreamSubscription? listener;
  StreamSubscription? listener2;
  StreamSubscription? listener3;

  @override
  void initState() {
    super.initState();
    loadDataAsync(); // เรียกใช้งานฟังก์ชันโหลดข้อมูล
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        CheckStatusOrder check = CheckStatusOrder();
        check.oid = 0;
        context.read<Appdata>().checkStatusOrder = check;
        if (listener != null) {
          listener!.cancel();
          listener = null;
          log('stop old listener');
        }
        if (listener2 != null) {
          listener2!.cancel();
          listener2 = null;
          log('stop old listener2');
        }
        if (listener3 != null) {
          listener3!.cancel();
          listener3 = null;
          log('stop old listener3');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFFF),
        ),
        body: Column(
          children: [
            if (isLoading) // แสดงสถานะกำลังโหลดถ้ากำลังโหลด
              SizedBox(
                width: Get.width / 1.1,
                height: Get.height / 3,
                child: const Center(
                  child: CircularProgressIndicator(), // แสดง loading indicator
                ),
              )
            else
              SizedBox(
                width: Get.width / 1.1,
                height: Get.height / 3,
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: latLng,
                    initialZoom: 17.0,
                    onTap: (tapPosition, point) {
                      // mapController.move(latLng, mapController.camera.zoom);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                      maxNativeZoom: 19,
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: latLng,
                          width: 40,
                          height: 40,
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.location_on_sharp,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                    (dataRider != null &&
                            orderDoc['latLngRider']['latitude'] != null &&
                            orderDoc['latLngRider']['longitude'] != null)
                        ? MarkerLayer(
                            markers: [
                              Marker(
                                point: latLngRider,
                                width: 40,
                                height: 40,
                                child: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.motorcycle,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ],
                          )
                        : Container(), // วาดเส้นทางระหว่างมาร์ค
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [
                            latLng,
                            latLngRider
                          ], // เส้นทางระหว่างตำแหน่งเริ่มต้นและไรเดอร์
                          color: Colors.orange,
                          strokeWidth: 4.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            dataRider != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Get.textTheme.titleLarge!.fontSize!),
                    child: Container(
                        width: Get.width / 1.2, // กำหนดความกว้างของ Container
                        height: Get.height / 10, // กำหนดความสูงของ Container
                        decoration: BoxDecoration(
                          color: Colors.white, // สีพื้นหลังของ Container
                          border: Border.all(
                              color: const Color.fromARGB(127, 153, 153, 153),
                              width: 1), // ขอบสีดำ
                          borderRadius: BorderRadius.circular(12), // โค้งขอบ
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClipOval(
                              child: (dataRider['image'] != null)
                                  ? Image.network(
                                      dataRider['image'],
                                      width: Get.height / 12,
                                      height: Get.height / 12,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // ถ้าเกิดข้อผิดพลาดในการโหลดรูปจาก URL
                                        return Image.asset(
                                          context
                                              .read<Appdata>()
                                              .imageNetworkError,
                                          width: Get.height / 12,
                                          height: Get.height / 12,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      context.read<Appdata>().imageDefaltRider,
                                      width: Get.height / 12,
                                      height: Get.height / 12,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Get.textTheme.bodySmall!.fontSize!),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataRider['name'],
                                    style: TextStyle(
                                      fontSize:
                                          Get.textTheme.titleMedium!.fontSize,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          Get.textTheme.bodySmall!.fontSize!),
                                  Text(dataRider['phone'],
                                      style: TextStyle(
                                        fontSize:
                                            Get.textTheme.titleMedium!.fontSize,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF747783),
                                      )),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      Get.textTheme.titleMedium!.fontSize! * 6,
                                  height:
                                      Get.textTheme.titleMedium!.fontSize! * 2,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE53935),
                                    borderRadius:
                                        BorderRadius.circular(8), // โค้งขอบ
                                  ),
                                  child: Text(
                                    dataRider['numCar'],
                                    style: TextStyle(
                                      fontSize:
                                          Get.textTheme.titleMedium!.fontSize,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                  )
                : Container(
                    height: Get.height / 10,
                  ),
            orderDoc != null
                ? // แสดงสถานะกำลังโหลดถ้ากำลังโหลด

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // สีพื้นหลังของ Container
                          border: Border.all(
                              color: const Color.fromARGB(127, 153, 153, 153),
                              width: 1), // ขอบสีดำ
                          borderRadius: BorderRadius.circular(12), // โค้งขอบ
                        ),
                        width: Get.width / 5,
                        height: Get.height / 2.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.watch_later_outlined, // ไอคอนเครื่องหมายถูก
                              size: Get.textTheme.titleSmall!.fontSize! * 2.5,
                              color:
                                  orderDoc['status'] == "รอไรเดอร์มารับสินค้า"
                                      ? const Color(0xFFFF7622)
                                      : const Color(
                                          0xFFBFBCBA), // เปลี่ยนสีตามสถานะ
                            ),
                            Container(
                              width: 5,
                              height: Get.textTheme.titleSmall!.fontSize! * 3,
                              color: orderDoc['status'] == "ไรเดอร์รับงาน"
                                  ? const Color(0xFFFF7622)
                                  : const Color(
                                      0xFFBFBCBA), // เปลี่ยนสีเส้นตามสถานะ
                            ),
                            Icon(
                              Icons.check_circle,
                              size: Get.textTheme.titleSmall!.fontSize! * 2.5,
                              color: orderDoc['status'] == "ไรเดอร์รับงาน"
                                  ? const Color(0xFFFF7622)
                                  : const Color(
                                      0xFFBFBCBA), // เปลี่ยนสีตามสถานะ
                            ),
                            Container(
                              width: 5,
                              height: Get.textTheme.titleSmall!.fontSize! * 3,
                              color: orderDoc['status'] ==
                                      "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง"
                                  ? const Color(0xFFFF7622)
                                  : const Color(
                                      0xFFBFBCBA), // เปลี่ยนสีเส้นตามสถานะ
                            ),
                            Icon(
                              Icons.drive_eta_rounded,
                              size: Get.textTheme.titleSmall!.fontSize! * 2.5,
                              color: orderDoc['status'] ==
                                      "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง"
                                  ? const Color(0xFFFF7622)
                                  : const Color(
                                      0xFFBFBCBA), // เปลี่ยนสีตามสถานะ
                            ),
                            Container(
                              width: 5,
                              height: Get.textTheme.titleSmall!.fontSize! * 3,
                              color:
                                  orderDoc['status'] == "ไรเดอร์นำส่งสินค้าแล้ว"
                                      ? const Color(0xFFFF7622)
                                      : const Color(
                                          0xFFBFBCBA), // เปลี่ยนสีเส้นตามสถานะ
                            ),
                            Icon(
                              Icons.location_on_rounded,
                              size: Get.textTheme.titleSmall!.fontSize! * 2.5,
                              color:
                                  orderDoc['status'] == "ไรเดอร์นำส่งสินค้าแล้ว"
                                      ? const Color(0xFFFF7622)
                                      : const Color(
                                          0xFFBFBCBA), // เปลี่ยนสีตามสถานะ
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Get.width / 1.4,
                        height: Get.height / 2.5,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Get.textTheme.headlineLarge!.fontSize!),
                                child: Text(
                                  "รอไรเดอร์มารับสินค้า",
                                  style: TextStyle(
                                    fontSize:
                                        Get.textTheme.titleLarge!.fontSize,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: orderDoc['status'] ==
                                            "รอไรเดอร์มารับสินค้า"
                                        ? const Color(0xFFFF7622)
                                        : const Color(
                                            0xFF000000), // เปลี่ยนสีข้อความตามสถานะ
                                  ),
                                ),
                              ),
                              orderDoc['image'] != null
                                  ? Image.network(
                                      orderDoc['image'],
                                      width: Get.width,
                                    )
                                  : Container(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Get.textTheme.headlineLarge!.fontSize!),
                                child: Text(
                                  "ไรเดอร์รับงาน",
                                  style: TextStyle(
                                    fontSize:
                                        Get.textTheme.titleLarge!.fontSize,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: orderDoc['status'] == "ไรเดอร์รับงาน"
                                        ? const Color(0xFFFF7622)
                                        : const Color(
                                            0xFF000000), // เปลี่ยนสีข้อความตามสถานะ
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Get.textTheme.headlineLarge!.fontSize!),
                                child: Text(
                                  "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง",
                                  style: TextStyle(
                                    fontSize:
                                        Get.textTheme.titleLarge!.fontSize,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: orderDoc['status'] ==
                                            "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง"
                                        ? const Color(0xFFFF7622)
                                        : const Color(
                                            0xFF000000), // เปลี่ยนสีข้อความตามสถานะ
                                  ),
                                ),
                              ),
                              orderDoc['image2'] != null
                                  ? Image.network(
                                      orderDoc['image2'],
                                      width: Get.width,
                                    )
                                  : Container(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Get.textTheme.headlineLarge!.fontSize!),
                                child: Text(
                                  "ไรเดอร์นำส่งสินค้าแล้ว",
                                  style: TextStyle(
                                    fontSize:
                                        Get.textTheme.titleLarge!.fontSize,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: orderDoc['status'] ==
                                            "ไรเดอร์นำส่งสินค้าแล้ว"
                                        ? const Color(0xFFFF7622)
                                        : const Color(
                                            0xFF000000), // เปลี่ยนสีข้อความตามสถานะ
                                  ),
                                ),
                              ),
                              orderDoc['image3'] != null
                                  ? Image.network(
                                      orderDoc['image3'],
                                      width: Get.width,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: Get.width / 1.1,
                    height: Get.height / 3,
                    child: const Center(
                      child:
                          CircularProgressIndicator(), // แสดง loading indicator
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> loadDataAsync() async {
    order = context.read<Appdata>().checkStatusOrder;
    final docRef = db.collection("order").doc(order.oid.toString());

    // ยกเลิก listener ก่อนหน้า
    if (listener != null) {
      listener!.cancel();
      listener = null;
      log('stop old listener');
    }

    // ฟังการเปลี่ยนแปลงข้อมูล Order
    listener = docRef.snapshots().listen(
      (orderSnapshot) async {
        
        orderDoc = orderSnapshot.data();
        var uidReceive = orderDoc['uidReceive'];
        var uidShipping = orderDoc['uidShipping'];
        var idRider = orderDoc['idRider'];
        if (idRider == null) {
          dataRider.toString();
        }
        var orderStatus = orderDoc['status'];
        log(orderDoc.toString());
        // ยกเลิก listener2 ก่อนหน้า
        if (listener2 != null) {
          listener2!.cancel();
          listener2 = null;
          log('stop old listener2');
        }
         // ยกเลิก listener3 ก่อนหน้า
        if (listener3 != null) {
          listener3!.cancel();
          listener3 = null;
          log('stop old listener3');
        }
        // กำหนดตัวแปร query สำหรับ user และ rider
        var userQuery;
        var riderQuery;

        // ตรวจสอบสถานะของ Order
        if (orderStatus == "รอไรเดอร์มารับสินค้า") {
          userQuery = db.collection("user").where("id", isEqualTo: uidShipping);
        } else if (orderStatus == "ไรเดอร์รับงาน" && idRider != null) {
          userQuery = db.collection("user").where("id", isEqualTo: uidShipping);
          riderQuery = db.collection("rider").where("id", isEqualTo: idRider);
        } else if (orderStatus == "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง") {
          userQuery = db.collection("user").where("id", isEqualTo: uidReceive);
        } else {
          userQuery = db.collection("user").where("id", isEqualTo: uidReceive);
        }

        log(userQuery.toString());
        log(riderQuery.toString());
        // ฟังการเปลี่ยนแปลงข้อมูลของ user
        listener2 = userQuery.snapshots().listen(
          (userSnapshot) async {
            if (userSnapshot.docs.isNotEmpty) {
              dataUser = await userSnapshot.docs.first.data();
              latLng = LatLng(dataUser['latLng']['latitude'],
                  dataUser['latLng']['longitude']);
              isLoading = false;
              setState(() {});
              mapController.move(latLng, mapController.camera.zoom);
            } else {
              log("ไม่พบข้อมูลผู้ใช้");
            }
            setState(() {}); // อัปเดต UI
          },
          onError: (error) => log("User listen failed: $error"),
        );
        // ฟังการเปลี่ยนแปลงข้อมูลของ rider ถ้ามี
        if (idRider != null && riderQuery != null) {
          listener3 = riderQuery.snapshots().listen(
            (riderSnapshot) {
              if (riderSnapshot.docs.isNotEmpty) {
                dataRider = riderSnapshot.docs.first.data();
                latLngRider = LatLng(orderDoc['latLngRider']['latitude'],
                    orderDoc['latLngRider']['longitude']);
                setState(() {});
              } else {
                log("ไม่พบข้อมูลไรเดอร์");
              }
              setState(() {}); // อัปเดต UI
            },
            onError: (error) => log("Rider listen failed: $error"),
          );
        }
      },
      onError: (error) => log("Order listen failed: $error"),
    );
  }
}
