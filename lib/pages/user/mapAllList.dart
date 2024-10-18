import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapAllList extends StatefulWidget {
  const MapAllList({super.key});

  @override
  State<MapAllList> createState() => _MapAllListState();
}

class _MapAllListState extends State<MapAllList> {
  MapController mapController = MapController();
  bool isLoading = true; // สถานะการโหลด
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  var db = FirebaseFirestore.instance;
  UserProfile userProfile = UserProfile();
  CheckStatusAllOrder order = CheckStatusAllOrder();
  String? imageUrl;
  var dataUser;
  List<Map<String, dynamic>> orderList = []; // ลิสต์สำหรับเก็บรายการ

  @override
  void initState() {
    super.initState();
    userProfile = context.read<Appdata>().user;
    order = context.read<Appdata>().checkStatusAllOrder;
    loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (context.read<Appdata>().listener3 != null) {
          context.read<Appdata>().listener3!.cancel();
          context.read<Appdata>().listener3 = null;
          log('stop old listener3');
        }
        CheckStatusAllOrder check = CheckStatusAllOrder();
        check.type = "";
        context.read<Appdata>().checkStatusAllOrder = check;
        if (order.order != null) {
          order.order!.cancel();
          order.order = null;
          log('stop old order');
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(
          //   backgroundColor: Colors.white,
          // ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: latLng,
                  initialZoom: 17.0,
                  onTap: (tapPosition, point) {
                    // setState(() {
                    //   latLng = point; // อัพเดตตำแหน่งของ Marker ตามที่คลิก
                    //   log(latLng.toString());
                    // });
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
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipOval(
                            child: (imageUrl != null)
                                ? Image.network(
                                    imageUrl!,
                                    width:
                                        Get.height / 6, // กำหนดความกว้างของรูป
                                    height:
                                        Get.height / 6, // กำหนดความสูงของรูป
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // ถ้าเกิดข้อผิดพลาดในการโหลดรูปจาก URL
                                      return Image.asset(
                                        context
                                            .read<Appdata>()
                                            .imageNetworkError,
                                        width: Get.height / 6,
                                        height: Get.height / 6,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    context.read<Appdata>().imageDefaltUser,
                                    width:
                                        Get.height / 6, // กำหนดความกว้างของรูป
                                    height:
                                        Get.height / 6, // กำหนดความสูงของรูป
                                    fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                                  ),
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                      ...orderList
                          .where((order) =>
                              order['latLngRider'] !=
                                  null && // ตรวจสอบว่ามีข้อมูล latLngRider
                              order['latLngRider']['latitude'] !=
                                  null && // ตรวจสอบ latitude ไม่เป็น null
                              order['latLngRider']['longitude'] !=
                                  null) // ตรวจสอบ longitude ไม่เป็น null
                          .map((order) => Marker(
                                point: LatLng(order['latLngRider']['latitude'],
                                    order['latLngRider']['longitude']),
                                width: 40,
                                height: 40,
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: ClipOval(
                                    child: (imageUrl != null)
                                        ? Image.network(
                                            order['image']!,
                                            width: Get.height /
                                                6, // กำหนดความกว้างของรูป
                                            height: Get.height /
                                                6, // กำหนดความสูงของรูป
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                context
                                                    .read<Appdata>()
                                                    .imageNetworkError,
                                                width: Get.height / 6,
                                                height: Get.height / 6,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            context
                                                .read<Appdata>()
                                                .imageDefaltUser,
                                            width: Get.height /
                                                6, // กำหนดความกว้างของรูป
                                            height: Get.height /
                                                6, // กำหนดความสูงของรูป
                                            fit: BoxFit
                                                .cover, // ทำให้รูปเต็มพื้นที่
                                          ),
                                  ),
                                ),
                                alignment: Alignment.center,
                              ))
                          .toList(), // แปลงผลลัพธ์ map เป็นลิสต์
                    ],
                  ),
                ],
              ),
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
              if (isLoading) // แสดงสถานะกำลังโหลดถ้ากำลังโหลด
                Container(
                  color: Colors.white, // กำหนดพื้นหลังเป็นสีขาว
                  child: const Center(
                    child: CircularProgressIndicator(), // กำลังโหลด
                  ),
                ),
            ],
          )),
    );
  }

  void loadDataAsync() async {
    final docRef = await db.collection("user").doc(userProfile.id.toString());
    if (context.read<Appdata>().listener3 != null) {
      context.read<Appdata>().listener3!.cancel();
      context.read<Appdata>().listener3 = null;
    }
    context.read<Appdata>().listener3 = await docRef.snapshots().listen(
      (event) async {
        dataUser = await event.data();
        imageUrl = dataUser['image'];
        if (dataUser['latLng'] != null && dataUser['latLng'] is Map) {
          latLng = LatLng(
              dataUser['latLng']['latitude'], dataUser['latLng']['longitude']);
        }
        mapController.move(latLng, mapController.camera.zoom);
        isLoading = false;
        setState(() {}); // Update the UI when data is loaded
      },
      onError: (error) => log("Listen failed: $error"),
    );
    var docOrder;
    if (order.type == "shipping") {
      docOrder = db
          .collection("order")
          .where("uidShipping", isEqualTo: userProfile.id);
    } else if (order.type == "receive") {
      docOrder =
          db.collection("order").where("uidReceive", isEqualTo: userProfile.id);
    }
    order.order = docOrder.snapshots().listen(
      (orderSnapshot) {
        if (orderSnapshot.docs.isNotEmpty) {
          orderList.clear(); // Clear list before adding new data
          var orderDocs = orderSnapshot.docs.toList();
          for (var orderDoc in orderDocs) {
            orderList.add({
              'orderData': orderDoc.data(), // Add order data
            });
          }
          setState(() {}); // Update UI
        } else {
          orderList = [];
          setState(() {}); // Update UI when no data
        }
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }
}
