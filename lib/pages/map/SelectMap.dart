import 'dart:developer';

import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class SelectMapPage extends StatefulWidget {
  const SelectMapPage({super.key});

  @override
  State<SelectMapPage> createState() => _SelectMapPageState();
}

class _SelectMapPageState extends State<SelectMapPage> {
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  MapController mapController = MapController();
  bool isLoading = true; // สถานะการโหลด

  @override
  void initState() {
    super.initState();
    currentMap(); // เรียกใช้เพื่อดึงตำแหน่งปัจจุบัน
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: latLng,
              initialZoom: 17.0,
              onTap: (tapPosition, point) {
                setState(() {
                  latLng = point; // อัพเดตตำแหน่งของ Marker ตามที่คลิก
                  log(latLng.toString());
                });
                mapController.move(latLng, mapController.camera.zoom);
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
            ],
          ),
          if (isLoading) // แสดงสถานะกำลังโหลดถ้ากำลังโหลด
            Container(
              color: Colors.white, // กำหนดพื้นหลังเป็นสีขาว
              child: const Center(
                child: CircularProgressIndicator(), // กำลังโหลด
              ),
            ),
          if (!isLoading)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: Get.textTheme.titleMedium?.fontSize ?? 16.0,
                  left: Get.textTheme.titleMedium?.fontSize ?? 16.0,
                  right: Get.textTheme.titleMedium?.fontSize ?? 16.0,
                ),
                child: FilledButton(
                  onPressed: () async {
                    setMap();
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                        Size(btnSizeWidth * 5, btnSizeHeight * 1.8)),
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xFFFF7622)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    )),
                  ),
                  child: Text('เลือก',
                      style: TextStyle(
                        fontSize: Get.textTheme.titleLarge?.fontSize,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFFFFF),
                      )),
                ),
              ),
            )
        ],
      ),
    );
  }

  setMap() async {
    context.read<Appdata>().latLng = latLng; // บันทึกตำแหน่งปัจจุบัน
    Navigator.of(context).pop();
    setState(() {});
  }

  currentMap() async {
    try {
      var position = await _determinePosition(); // ดึงตำแหน่งปัจจุบัน
      setState(() {
        //อัพเดตตำแหน่งปัจจุบัน
        latLng = LatLng(position.latitude, position.longitude);
        isLoading = false; // ตั้งค่าเป็นไม่โหลดเมื่อได้ตำแหน่ง
        mapController.move(latLng, mapController.camera.zoom);
      });
    } catch (e) {
      setState(() {
        isLoading = false; // ตั้งค่าเป็นไม่โหลด
      });
      log('Error: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}