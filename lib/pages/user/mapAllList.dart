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
  String? imageUrl;
  var dataUser;
  @override
  void initState() {
    super.initState();
    userProfile = context.read<Appdata>().user;
    final docRef = db.collection("user").doc(userProfile.id.toString());
    if (context.read<Appdata>().listener3 != null) {
      context.read<Appdata>().listener3!.cancel();
      context.read<Appdata>().listener3 = null;
    }
    context.read<Appdata>().listener3 = docRef.snapshots().listen(
      (event) {
        dataUser = event.data();
        imageUrl = dataUser['image'];
        setState(() {}); // Update the UI when data is loaded
      },
      onError: (error) => log("Listen failed: $error"),
    );
    isLoading = false;
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
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                                    width: Get.height / 6, // กำหนดความกว้างของรูป
                                    height: Get.height / 6, // กำหนดความสูงของรูป
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // ถ้าเกิดข้อผิดพลาดในการโหลดรูปจาก URL
                                      return Image.asset(
                                        context.read<Appdata>().imageNetworkError,
                                        width: Get.height / 6,
                                        height: Get.height / 6,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    context.read<Appdata>().imageDefaltUser,
                                    width: Get.height / 6, // กำหนดความกว้างของรูป
                                    height: Get.height / 6, // กำหนดความสูงของรูป
                                    fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                                  ),
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
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
}
