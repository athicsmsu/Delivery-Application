import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String MarkName = "";

  var orderDoc;
  var dataReceive;
  var dataShipping;
  var dataRider;
  var initialSize = 0.55; // ขนาดเริ่มต้น
  var minSize = 0.21; // ขนาดต่ำสุดเมื่อถูกซ่อนไว้
  var maxSize = 0.9;

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
        if (order.listener != null) {
          order.listener!.cancel();
          order.listener = null;
          log('stop old listener');
        }
        if (order.listener2 != null) {
          order.listener2!.cancel();
          order.listener2 = null;
          log('stop old listener2');
        }
        if (order.listener3 != null) {
          order.listener3!.cancel();
          order.listener3 = null;
          log('stop old listener3');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFFF),
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFFFFFFFFF),
        // ),
        body: Stack(
          children: [
            if (isLoading) // แสดงสถานะกำลังโหลดถ้ากำลังโหลด
              SizedBox(
                width: Get.width,
                height: Get.height / 1.5,
                child: const Center(
                  child: CircularProgressIndicator(), // แสดง loading indicator
                ),
              )
            else
              SizedBox(
                width: Get.width,
                height: Get.height,
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
                          width: 80,
                          height: 80,
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.red, // สีพื้นหลังของ Container
                                    // ขอบสีดำ
                                    borderRadius:
                                        BorderRadius.circular(12), // โค้งขอบ
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: SizedBox(
                                    child: Text(
                                      "จุดหมาย",
                                      style: TextStyle(
                                        fontSize:
                                            Get.textTheme.bodyLarge!.fontSize,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ],
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
                        : Container(),
                  ],
                ),
              ),
            // วาง IconButton ไว้บนสุด
            Positioned(
              top: Get.textTheme.headlineLarge!.fontSize!,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: Get.textTheme.headlineMedium!.fontSize!,
                ), // ปุ่ม Back
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            orderDoc != null
                ? // แสดงสถานะกำลังโหลดถ้ากำลังโหลด
                Column(
                    children: [
                      Expanded(
                        child: DraggableScrollableSheet(
                          initialChildSize: initialSize, // ขนาดเริ่มต้น
                          minChildSize: minSize, // ขนาดต่ำสุดเมื่อถูกซ่อนไว้
                          maxChildSize: maxSize, // ขนาดใหญ่สุดเมื่อเลื่อนขึ้น
                          builder: (context, scrollController) {
                            return Container(
                              child: SingleChildScrollView(
                                controller:
                                    scrollController, // ใช้ controller เพื่อให้ Scroll ได้
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get
                                              .textTheme.titleSmall!.fontSize!,
                                          vertical: Get
                                              .textTheme.titleSmall!.fontSize!),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.textTheme.bodySmall!
                                                .fontSize!),
                                        decoration: BoxDecoration(
                                            color: Colors
                                                .white, // สีพื้นหลังของ Container

                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                color:
                                                    Colors.black26, // เงาของขอบ
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                              ),
                                            ] // โค้งขอบ
                                            ),
                                        width: Get.width,
                                        height: Get.height / 7,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: Get.textTheme
                                                      .bodySmall!.fontSize!),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    orderDoc['status'],
                                                    style: TextStyle(
                                                      fontSize: Get
                                                          .textTheme
                                                          .headlineMedium!
                                                          .fontSize,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xFFFF7622),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .watch_later_outlined, // ไอคอนเครื่องหมายถูก
                                                  size: Get
                                                          .textTheme
                                                          .titleSmall!
                                                          .fontSize! *
                                                      2.5,
                                                  color: (orderDoc['status'] == "รอไรเดอร์มารับสินค้า" ||
                                                          orderDoc['status'] ==
                                                              "ไรเดอร์รับงาน" ||
                                                          orderDoc['status'] ==
                                                              "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง" ||
                                                          orderDoc['status'] ==
                                                              "ไรเดอร์นำส่งสินค้าแล้ว")
                                                      ? const Color(0xFFFF7622)
                                                      : const Color(
                                                          0xFFBFBCBA), // เปลี่ยนสีตามสถานะ
                                                ),
                                                Container(
                                                  height: 5,
                                                  width: Get
                                                          .textTheme
                                                          .titleSmall!
                                                          .fontSize! *
                                                      3,
                                                  color: (orderDoc['status'] == "ไรเดอร์รับงาน" ||
                                                          orderDoc['status'] ==
                                                              "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง" ||
                                                          orderDoc['status'] ==
                                                              "ไรเดอร์นำส่งสินค้าแล้ว")
                                                      ? const Color(0xFFFF7622)
                                                      : const Color(
                                                          0xFFBFBCBA), // เปลี่ยนสีเส้นตามสถานะ
                                                ),
                                                Icon(
                                                  Icons.check_circle,
                                                  size: Get
                                                          .textTheme
                                                          .titleSmall!
                                                          .fontSize! *
                                                      2.5,
                                                  color: (orderDoc['status'] == "ไรเดอร์รับงาน" ||
                                                          orderDoc['status'] ==
                                                              "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง" ||
                                                          orderDoc['status'] ==
                                                              "ไรเดอร์นำส่งสินค้าแล้ว")
                                                      ? const Color(0xFFFF7622)
                                                      : const Color(
                                                          0xFFBFBCBA), // เปลี่ยนสีตามสถานะ
                                                ),
                                                Container(
                                                  height: 5,
                                                  width: Get
                                                          .textTheme
                                                          .titleSmall!
                                                          .fontSize! *
                                                      3,
                                                  color: (orderDoc['status'] == "ไรเดอร์รับงาน" ||orderDoc['status'] ==
                                                              "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง" ||
                                                          orderDoc['status'] ==
                                                              "ไรเดอร์นำส่งสินค้าแล้ว")
                                                      ? const Color(0xFFFF7622)
                                                      : const Color(
                                                          0xFFBFBCBA), // เปลี่ยนสีเส้นตามสถานะ
                                                ),
                                                Icon(
                                                  Icons.drive_eta_rounded,
                                                  size: Get
                                                          .textTheme
                                                          .titleSmall!
                                                          .fontSize! *
                                                      2.5,
                                                  color: (orderDoc['status'] ==
                                                              "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง" ||
                                                          orderDoc['status'] ==
                                                              "ไรเดอร์นำส่งสินค้าแล้ว")
                                                      ? const Color(0xFFFF7622)
                                                      : const Color(
                                                          0xFFBFBCBA), // เปลี่ยนสีตามสถานะ
                                                ),
                                                Container(
                                                  height: 5,
                                                  width: Get
                                                          .textTheme
                                                          .titleSmall!
                                                          .fontSize! *
                                                      3,
                                                  color: (orderDoc['status'] ==
                                                          "ไรเดอร์นำส่งสินค้าแล้ว")
                                                      ? const Color(0xFFFF7622)
                                                      : const Color(
                                                          0xFFBFBCBA), // เปลี่ยนสีเส้นตามสถานะ
                                                ),
                                                Icon(
                                                  Icons.location_on_rounded,
                                                  size: Get
                                                          .textTheme
                                                          .titleSmall!
                                                          .fontSize! *
                                                      2.5,
                                                  color: (orderDoc['status'] ==
                                                          "ไรเดอร์นำส่งสินค้าแล้ว")
                                                      ? const Color(0xFFFF7622)
                                                      : const Color(
                                                          0xFFBFBCBA), // เปลี่ยนสีตามสถานะ
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors
                                            .white, // สีพื้นหลังของ Container
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26, // เงาของขอบ
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(18),
                                            topRight:
                                                Radius.circular(18)), // โค้งขอบ
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Center(
                                              child: Container(
                                                width: Get.width / 3,
                                                height: Get.textTheme.bodySmall!
                                                        .fontSize! /
                                                    1.5,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                      0xFFBFBCBA), // ขอบสีดำ
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // โค้งขอบ
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Get.textTheme
                                                    .bodySmall!.fontSize!),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors
                                                      .white, // สีพื้นหลังของ Container
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // โค้งขอบ
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors
                                                          .black26, // เงาของขอบ
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                    ),
                                                  ]),
                                              child: Column(
                                                children: [
                                                  dataRider != null
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            ClipOval(
                                                              child: (dataRider[
                                                                          'image'] !=
                                                                      null)
                                                                  ? Image
                                                                      .network(
                                                                      dataRider[
                                                                          'image'],
                                                                      width:
                                                                          Get.height /
                                                                              12,
                                                                      height:
                                                                          Get.height /
                                                                              12,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Image
                                                                            .asset(
                                                                          context
                                                                              .read<Appdata>()
                                                                              .imageNetworkError,
                                                                          width:
                                                                              Get.height / 12,
                                                                          height:
                                                                              Get.height / 12,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        );
                                                                      },
                                                                    )
                                                                  : Image.asset(
                                                                      context
                                                                          .read<
                                                                              Appdata>()
                                                                          .imageDefaltRider,
                                                                      width:
                                                                          Get.height /
                                                                              12,
                                                                      height:
                                                                          Get.height /
                                                                              12,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                vertical: Get
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .fontSize!,
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    dataRider[
                                                                            'name'] ??
                                                                        'full name',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: Get
                                                                          .textTheme
                                                                          .titleMedium!
                                                                          .fontSize,
                                                                      fontFamily:
                                                                          GoogleFonts.poppins()
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color(
                                                                          0xFF000000),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: Get
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .fontSize!),
                                                                  Text(
                                                                      dataRider[
                                                                              'phone'] ??
                                                                          "0987654321",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: Get
                                                                            .textTheme
                                                                            .titleMedium!
                                                                            .fontSize,
                                                                        fontFamily:
                                                                            GoogleFonts.poppins().fontFamily,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: const Color(
                                                                            0xFF747783),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: Get
                                                                          .textTheme
                                                                          .titleMedium!
                                                                          .fontSize! *
                                                                      6,
                                                                  height: Get
                                                                          .textTheme
                                                                          .titleMedium!
                                                                          .fontSize! *
                                                                      2,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                        0xFFE53935),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child: Text(
                                                                    dataRider[
                                                                            'numCar'] ??
                                                                        "te1222",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: Get
                                                                          .textTheme
                                                                          .titleMedium!
                                                                          .fontSize,
                                                                      fontFamily:
                                                                          GoogleFonts.poppins()
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color(
                                                                          0xFFFFFFFF),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
                                                  dataRider != null
                                                      ? const Divider(
                                                          color: Color.fromARGB(
                                                              130,
                                                              158,
                                                              158,
                                                              158), // สีของเส้น
                                                          thickness:
                                                              1, // ความหนาของเส้น
                                                        )
                                                      : Container(),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Get
                                                                .textTheme
                                                                .bodySmall!
                                                                .fontSize!,
                                                            vertical: Get
                                                                .textTheme
                                                                .bodySmall!
                                                                .fontSize!),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showDetailDialg();
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "ดูรายละเอียดสินค้า",
                                                            style: TextStyle(
                                                              fontSize: Get
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .fontSize,
                                                              fontFamily:
                                                                  GoogleFonts
                                                                          .poppins()
                                                                      .fontFamily,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: const Color(
                                                                  0xFFE53935),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: Get
                                                                        .textTheme
                                                                        .labelSmall!
                                                                        .fontSize! /
                                                                    2),
                                                            child: Icon(
                                                              Icons
                                                                  .keyboard_arrow_right_sharp,
                                                              size: Get
                                                                  .textTheme
                                                                  .headlineLarge!
                                                                  .fontSize!,
                                                              color: const Color(
                                                                  0xFFE53935),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          orderDoc['image'] != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.network(
                                                    orderDoc['image'],
                                                    height: Get.height / 3,
                                                  ),
                                                )
                                              : Container(),
                                          orderDoc['image2'] != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.network(
                                                    orderDoc['image2'],
                                                    height: Get.height / 3,
                                                  ),
                                                )
                                              : Container(),
                                          orderDoc['image3'] != null
                                              ? Image.network(
                                                  orderDoc['image3'],
                                                  height: Get.height / 3,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<void> loadDataAsync() async {
    order = context.read<Appdata>().checkStatusOrder;
    final docOrder = db.collection("order").doc(order.oid.toString());
    // ยกเลิก listener ก่อนหน้า
    if (order.listener != null) {
      order.listener!.cancel();
      order.listener = null;
      log('stop listener order');
    }

    // ฟังการเปลี่ยนแปลงข้อมูล Order
    order.listener = docOrder.snapshots().listen(
      (orderSnapshot) async {
        orderDoc = await orderSnapshot.data();
        var orderStatus = orderDoc['status'];
        var uidReceive = orderDoc['uidReceive'];
        var uidShipping = orderDoc['uidShipping'];
        var idRider = orderDoc['idRider'];

        if (idRider == null) {
          dataReceive = null;
          dataRider = null;
        }
        // ยกเลิก listener2 ก่อนหน้า
        if (order.listener2 != null) {
          order.listener2!.cancel();
          order.listener2 = null;
          log('stop old listener2');
        }
        // ยกเลิก listener3 ก่อนหน้า
        if (order.listener3 != null) {
          order.listener3!.cancel();
          order.listener3 = null;
          log('stop old listener3');
        }
        // ยกเลิก listener3 ก่อนหน้า
        if (order.listener4 != null) {
          order.listener4!.cancel();
          order.listener4 = null;
          log('stop old listener3');
        }
        // กำหนดตัวแปร query สำหรับ user และ rider
        var ReceiveQuery;
        var ShippingQuery;
        var riderQuery;

        // ตรวจสอบสถานะของ Order
        if (orderStatus == "รอไรเดอร์มารับสินค้า") {
          initialSize = 0.29; // ขนาดเริ่มต้น
          maxSize = 0.65;
          log(orderStatus);
          ShippingQuery =
              db.collection("user").where("id", isEqualTo: uidShipping);
          // ฟังการเปลี่ยนแปลงข้อมูลของ user
          order.listener2 = ShippingQuery.snapshots().listen(
            (userSnapshot) async {
              if (userSnapshot.docs.isNotEmpty) {
                dataShipping = await userSnapshot.docs.first.data();
                latLng = LatLng(dataShipping['latLng']['latitude'],
                    dataShipping['latLng']['longitude']);
              } else {
                log("ไม่พบข้อมูลผู้ใช้");
              }
              setState(() {}); // อัปเดต UI
            },
            onError: (error) => log("User listen failed: $error"),
          );
        } else if (orderStatus == "ไรเดอร์รับงาน") {
          initialSize = 0.41; // ขนาดเริ่มต้น
          maxSize = 0.75;
          log(orderStatus);
          ShippingQuery =
              db.collection("user").where("id", isEqualTo: uidShipping);
          riderQuery = db.collection("rider").where("id", isEqualTo: idRider);
          // ฟังการเปลี่ยนแปลงข้อมูลของ rider ถ้ามี
          order.listener2 = ShippingQuery.snapshots().listen(
            (userSnapshot) async {
              if (userSnapshot.docs.isNotEmpty) {
                dataShipping = await userSnapshot.docs.first.data();
                latLng = LatLng(dataShipping['latLng']['latitude'],
                    dataShipping['latLng']['longitude']);
              } else {
                log("ไม่พบข้อมูลผู้ใช้");
              }
              setState(() {}); // อัปเดต UI
            },
            onError: (error) => log("User listen failed: $error"),
          );
          isLoading = false;
          if (idRider != null && riderQuery != null) {
            order.listener3 = riderQuery.snapshots().listen(
              (riderSnapshot) async {
                if (riderSnapshot.docs.isNotEmpty) {
                  dataRider = await riderSnapshot.docs.first.data();
                  latLngRider = LatLng(orderDoc['latLngRider']['latitude'],
                      orderDoc['latLngRider']['longitude']);
                  setState(() {
                    mapController.move(latLngRider, mapController.camera.zoom);
                  });
                } else {
                  log("ไม่พบข้อมูลไรเดอร์");
                }
              },
              onError: (error) => log("Rider listen failed: $error"),
            );
          }
        } else if (orderStatus == "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง") {
          initialSize = 0.41; // ขนาดเริ่มต้น
          maxSize = 0.75;
          log(orderStatus);
          ReceiveQuery =
              db.collection("user").where("id", isEqualTo: uidReceive);
          riderQuery = db.collection("rider").where("id", isEqualTo: idRider);
          // ฟังการเปลี่ยนแปลงข้อมูลของ rider ถ้ามี
          order.listener2 = ReceiveQuery.snapshots().listen(
            (userSnapshot) async {
              if (userSnapshot.docs.isNotEmpty) {
                dataShipping = await userSnapshot.docs.first.data();
                latLng = LatLng(dataShipping['latLng']['latitude'],
                    dataShipping['latLng']['longitude']);
              } else {
                log("ไม่พบข้อมูลผู้ใช้");
              }
              setState(() {}); // อัปเดต UI
            },
            onError: (error) => log("User listen failed: $error"),
          );
          isLoading = false;
          if (idRider != null && riderQuery != null) {
            order.listener3 = riderQuery.snapshots().listen(
              (riderSnapshot) async {
                if (riderSnapshot.docs.isNotEmpty) {
                  dataRider = await riderSnapshot.docs.first.data();
                  latLngRider = LatLng(orderDoc['latLngRider']['latitude'],
                      orderDoc['latLngRider']['longitude']);
                  setState(() {
                    mapController.move(latLng, mapController.camera.zoom);
                  });
                } else {
                  log("ไม่พบข้อมูลไรเดอร์");
                }
              },
              onError: (error) => log("Rider listen failed: $error"),
            );
          }
        } else if (orderStatus == "ไรเดอร์นำส่งสินค้าแล้ว") {
          initialSize = 0.41; // ขนาดเริ่มต้น
          maxSize = 0.75;
          log(orderStatus);
          riderQuery = db.collection("rider").where("id", isEqualTo: idRider);
          isLoading = false;
          if (idRider != null && riderQuery != null) {
            order.listener3 = riderQuery.snapshots().listen(
              (riderSnapshot) async {
                if (riderSnapshot.docs.isNotEmpty) {
                  dataRider = await riderSnapshot.docs.first.data();
                  latLngRider = LatLng(orderDoc['latLngRider']['latitude'],
                      orderDoc['latLngRider']['longitude']);
                  setState(() {
                    mapController.move(latLng, mapController.camera.zoom);
                  });
                } else {
                  log("ไม่พบข้อมูลไรเดอร์");
                }
              },
              onError: (error) => log("Rider listen failed: $error"),
            );
          }
        }
        setState(() {});
      },
      onError: (error) => log("Order listen failed: $error"),
    );
  }

  
void showDetailDialg() {
    showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(
            "title",
            style: TextStyle(
              fontSize: Get.textTheme.headlineMedium!.fontSize,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE53935),
              // letterSpacing: 1
            ),
          ),
          content: Text(
            orderDoc["detail"],
            style: TextStyle(
              fontSize: Get.textTheme.titleLarge!.fontSize,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF7622),
              // letterSpacing: 1
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFE53935)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                )),
              ),
              child: Text(
                'ปิด',
                style: TextStyle(
                  fontSize: Get.textTheme.titleLarge!.fontSize,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFFFFF),
                  // letterSpacing: 1
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
