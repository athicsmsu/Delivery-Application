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

  @override
  void initState() {
    super.initState();
    currentMap();
  }

  setMap() async {
    context.read<Appdata>().latLng = latLng;
    Navigator.of(context).pop();
    setState(() {});
  }

  currentMap() async{
    var position = await _determinePosition();
    latLng = LatLng(position.latitude, position.longitude);
    mapController.move(latLng, mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: latLng,
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                // เมื่อผู้ใช้คลิกที่แผนที่
                setState(() {
                  latLng = point; // อัพเดตตำแหน่งของ Marker ตามที่คลิก
                  log(latLng.toString());
                });
                mapController.move(latLng, mapController.camera.zoom);
              },
            ),
            children: [
              TileLayer(
                // Display map tiles from any source
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                userAgentPackageName: 'com.example.app',
                maxNativeZoom:
                    19, // Scale tiles when the server doesn't support higher zoom levels
                // And many more recommended properties!
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
                        child: const Icon(
                          Icons.location_on_sharp,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                      alignment: Alignment.center),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: Get.textTheme.titleMedium!.fontSize!,
                  left: Get.textTheme.titleMedium!.fontSize!,
                  right: Get.textTheme.titleMedium!.fontSize!),
              child: FilledButton(
                  onPressed: () async {
                    setMap();
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(
                        btnSizeWidth * 5,
                        btnSizeHeight * 1.8)), // กำหนดขนาดของปุ่ม
                    backgroundColor: MaterialStateProperty.all(
                        const Color(0xFFFF7622)), // สีพื้นหลังของปุ่ม
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                    )),
                  ),
                  child: Text('เลือก',
                      style: TextStyle(
                        fontSize: Get.textTheme.titleLarge!.fontSize,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFFFFF),
                      ))),
            ),
          )
        ],
      ),
    );
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
