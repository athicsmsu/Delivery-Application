import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/rider/menuRider.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class mapRiderPage extends StatefulWidget {
  const mapRiderPage({super.key});

  @override
  State<mapRiderPage> createState() => _mapRiderPageState();
}

class _mapRiderPageState extends State<mapRiderPage> {
  GetStorage storage = GetStorage();
  XFile? imageReceive;
  XFile? imageSeccess;
  var db = FirebaseFirestore.instance;
  OrderID orderid = OrderID();
  MapController mapController = MapController();
  UserProfile userProfile = UserProfile();
  List<LatLng> polylinePoints = []; // เก็บจุดสำหรับเส้น
  late Future<void> loadData;
  var latLngRecivce;
  var latLngShipping;
  var latLngRider;
  int number = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderid = context.read<Appdata>().order;
    userProfile = context.read<Appdata>().user;
    loadData = loadDataAsync();
    startListening();
  }

  void startListening() {
    context.read<Appdata>().time =
        Stream.periodic(Duration(seconds: 3)).listen((event) {
      callMethod();
    });
  }

  void stopListening() {
    if (context.read<Appdata>().time != null) {
      context.read<Appdata>().time!.cancel(); // หยุดการฟัง
      context.read<Appdata>().time = null; // ตั้งค่าให้เป็น null หลังจากหยุด
      log("Stream stopped!");
    }
  }

  void callMethod() {
    loadDataAsync();
    if(number == 1){
      drawRouteToPickup();
    }
    else if(number == 2){
      drawRouteToDestination();
    }else{
      number = 0;
    }
  }

  void drawRouteToPickup() {
    number = 1;
    setState(() {
      polylinePoints = [
        latLngRider,
        latLngShipping
      ]; // สร้างเส้นระหว่าง Rider กับจุดรับสินค้า
    });
  }

  void drawRouteToDestination() {
    number = 2;
    setState(() {
      polylinePoints = [
        latLngRider,
        latLngRecivce
      ]; // สร้างเส้นระหว่าง Rider กับจุดหมาย
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder(
              future: loadData, // ฟังก์ชันที่ดึงข้อมูลจากฐานข้อมูล
              builder: (context, snapshot) {
                // ตรวจสอบสถานะการโหลดข้อมูล
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      SizedBox(height: Get.height / 2.5),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                }
                // ถ้ามี error ให้แสดงข้อความ error
                else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: Get.height / 5),
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
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        width: Get.height / 2.3, // กำหนดความกว้างของรูป
                        height: Get.height / 2.3,
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: latLngRider,
                            initialZoom: 17.0,
                            onTap: (tapPosition, point) {
                              mapController.move(
                                  latLngRider, mapController.camera.zoom);
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                              maxNativeZoom: 19,
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: polylinePoints,
                                  strokeWidth: 4.0,
                                  color: Colors.blue,
                                ),
                              ],
                            ),

                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: latLngShipping,
                                  width: 100,
                                  height: 80,
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 255, 136,
                                                0), // สีพื้นหลังของ Container
                                            // ขอบสีดำ
                                            borderRadius: BorderRadius.circular(
                                                12), // โค้งขอบ
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: SizedBox(
                                            child: Text(
                                              "จุดรับสินค้า",
                                              style: TextStyle(
                                                fontSize: Get.textTheme
                                                    .bodyLarge!.fontSize,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFFFFFFFFF),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.location_on_sharp,
                                          color:
                                              Color.fromARGB(255, 255, 136, 0),
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: latLngRecivce,
                                  width: 80,
                                  height: 80,
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .red, // สีพื้นหลังของ Container
                                            // ขอบสีดำ
                                            borderRadius: BorderRadius.circular(
                                                12), // โค้งขอบ
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: SizedBox(
                                            child: Text(
                                              "จุดหมาย",
                                              style: TextStyle(
                                                fontSize: Get.textTheme
                                                    .bodyLarge!.fontSize,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
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
                            MarkerLayer(
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
                            //: Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton(
                            
                            onPressed:
                            drawRouteToPickup,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 23, 135, 255)),
                              minimumSize:
                                  MaterialStateProperty.all(Size(50, 50)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12.0), // ทำให้ขอบมน
                              )),
                            ),
                            child: Text("ดูเส้นทางไปจุดรับ"),
                          ),
                          FilledButton(
                            onPressed: drawRouteToDestination,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 23, 135, 255)),
                              minimumSize:
                                  MaterialStateProperty.all(Size(50, 50)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12.0), // ทำให้ขอบมน
                              )),
                            ),
                            child: Text("ดูเส้นทางไปจุดหมาย"),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ถ่ายรูปสินค้าที่ได้รับ"),
                          SizedBox(height: 16.0),
                          (imageReceive != null)
                              ? GestureDetector(
                                  onTap: () async {
                                    chooseOptionUploadDialog(1);
                                  },
                                  child: Image.file(
                                    File(imageReceive!.path),
                                    width:
                                        Get.height / 5, // กำหนดความกว้างของรูป
                                    height:
                                        Get.height / 5, // กำหนดความสูงของรูป
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    chooseOptionUploadDialog(1);
                                  },
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(12),
                                    color: Colors.black,
                                    strokeWidth: 2,
                                    dashPattern: const [
                                      6,
                                      3
                                    ], // ความยาวของเส้นและช่องว่าง
                                    child: Container(
                                      width: Get.width / 1.25,
                                      height: Get.height / 15,
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons
                                                .camera_alt_outlined, // เปลี่ยนเป็นไอคอนที่ต้องการ
                                            size: Get.textTheme.titleLarge!
                                                    .fontSize! *
                                                1.5, // ขนาดของไอคอน
                                            color: const Color(
                                                0xFF444444), // สีของไอคอน
                                          ),
                                          SizedBox(
                                              width: Get.textTheme.titleLarge!
                                                  .fontSize!), // ระยะห่างระหว่างไอคอนและข้อความ
                                          Text(
                                            "เพิ่มรูปภาพ (จำเป็น)", // ข้อความที่ต้องการแสดง
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontSize: Get.textTheme
                                                  .titleLarge!.fontSize,
                                              color: const Color(
                                                  0xFF444444), // สีข้อความ
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 16.0),
                          FilledButton(
                              onPressed: () {
                                orderReceive();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF56DA40)),
                                minimumSize:
                                    MaterialStateProperty.all(Size(350, 60)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12.0), // ทำให้ขอบมน
                                )),
                              ),
                              child:
                                  Text("ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง")),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ถ่ายรูปสินค้าที่จัดส่งแล้ว"),
                          SizedBox(height: 16.0),
                          (imageSeccess != null)
                              ? GestureDetector(
                                  onTap: () async {
                                    chooseOptionUploadDialog(2);
                                  },
                                  child: Image.file(
                                    File(imageSeccess!.path),
                                    width:
                                        Get.height / 5, // กำหนดความกว้างของรูป
                                    height:
                                        Get.height / 5, // กำหนดความสูงของรูป
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    chooseOptionUploadDialog(2);
                                  },
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(12),
                                    color: Colors.black,
                                    strokeWidth: 2,
                                    dashPattern: const [
                                      6,
                                      3
                                    ], // ความยาวของเส้นและช่องว่าง
                                    child: Container(
                                      width: Get.width / 1.25,
                                      height: Get.height / 15,
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons
                                                .camera_alt_outlined, // เปลี่ยนเป็นไอคอนที่ต้องการ
                                            size: Get.textTheme.titleLarge!
                                                    .fontSize! *
                                                1.5, // ขนาดของไอคอน
                                            color: const Color(
                                                0xFF444444), // สีของไอคอน
                                          ),
                                          SizedBox(
                                              width: Get.textTheme.titleLarge!
                                                  .fontSize!), // ระยะห่างระหว่างไอคอนและข้อความ
                                          Text(
                                            "เพิ่มรูปภาพ (จำเป็น)", // ข้อความที่ต้องการแสดง
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontSize: Get.textTheme
                                                  .titleLarge!.fontSize,
                                              color: const Color(
                                                  0xFF444444), // สีข้อความ
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 16.0),
                          FilledButton(
                              onPressed: () {
                                orderSeccess();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF56DA40)),
                                minimumSize:
                                    MaterialStateProperty.all(Size(350, 60)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12.0), // ทำให้ขอบมน
                                )),
                              ),
                              child: Text("ไรเดอร์นำส่งสินค้าแล้ว")),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      FilledButton(
                          onPressed: () {
                            stopListening();
                            updateRiderStatus();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFFF7622)),
                            minimumSize:
                                MaterialStateProperty.all(Size(Get.width * 5, Get.textTheme.displaySmall!.fontSize! * 1.8)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12.0), // ทำให้ขอบมน
                            )),
                          ),
                          child: Text("เสร็จสิ้น",
                              style: TextStyle(
                                fontSize: Get.textTheme.titleSmall!.fontSize,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFFFFFF),
                              )))
                    ],
                  );
                }
              },
            ),
          ),
        ));
  }

  void chooseOptionUploadDialog(int choice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // ทำให้มุมโค้งมน
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(Get.textTheme.displaySmall!.fontSize! * 3,
                        Get.textTheme.titleLarge!.fontSize! * 2.5),
                    backgroundColor: const Color(0xFFFF7622),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleLarge!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF),
                      // letterSpacing: 1
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if(choice == 1){
                      final ImagePicker picker = ImagePicker();
                      imageReceive =
                          await picker.pickImage(source: ImageSource.camera);
                      if (imageReceive != null) {
                        log(imageReceive!.path);
                        setState(() {});
                      }
                    } else if(choice == 2){
                      final ImagePicker picker = ImagePicker();
                      imageSeccess =
                          await picker.pickImage(source: ImageSource.camera);
                      if (imageSeccess != null) {
                        log(imageSeccess!.path);
                        setState(() {});
                      }
                    }
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(Get.textTheme.displaySmall!.fontSize! * 3,
                        Get.textTheme.titleLarge!.fontSize! * 2.5),
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleLarge!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF),
                      // letterSpacing: 1
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (choice == 1) {
                      final ImagePicker picker = ImagePicker();
                      imageReceive =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (imageReceive != null) {
                        log(imageReceive!.path);
                        setState(() {});
                      }
                    } else {
                      final ImagePicker picker = ImagePicker();
                      imageSeccess =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (imageSeccess != null) {
                        log(imageSeccess!.path);
                        setState(() {});
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> loadDataAsync() async {
    var uidReceive;
    var uidShipping;

    try {
      var position = await _determinePosition(); // ดึงตำแหน่งปัจจุบัน
      log(position.toString());

      //อัพเดตตำแหน่งปัจจุบัน
      latLngRider = LatLng(position.latitude, position.longitude);
      var MyLat = position.latitude;
      var MyLng = position.longitude;

          await FirebaseFirestore.instance.collection("order").doc(orderid.oid.toString()).update({
          'latLngRider': {'latitude': MyLat, 'longitude': MyLng},
        });
      //isLoading = false; // ตั้งค่าเป็นไม่โหลดเมื่อได้ตำแหน่ง
    } catch (e) {
      setState(() {
        //isLoading = false; // ตั้งค่าเป็นไม่โหลด
      });
      log('Error: $e');
    }



    // ค้นหาข้อมูลการสั่งซื้อ
    var result =
        await db.collection("order").where('oid', isEqualTo: orderid.oid).get();

    if (result.docs.isNotEmpty) {
      var orderData = result.docs.toList();
      orderData.map((orderMap) {
        uidReceive = orderMap['uidReceive'];
        uidShipping = orderMap['uidShipping'];
      }).toList();
    } else {
      print("ไม่พบข้อมูลการสั่งซื้อ");
      return; // ออกจากฟังก์ชันหากไม่พบข้อมูล
    }

    // ตรวจสอบ uidReceive และ uidShipping ว่าไม่เป็น null
    if (uidReceive != null) {
      var userReceive =
          await db.collection("user").where('id', isEqualTo: uidReceive).get();

      if (userReceive.docs.isNotEmpty) {
        var userDataReceive = userReceive.docs.toList();
        userDataReceive.map((userMap) {
          latLngRecivce = LatLng(
            userMap['latLng']['latitude'],
            userMap['latLng']['longitude'],
          );
        }).toList();
      } else {
        print("ไม่พบข้อมูลผู้รับ");
      }
    } else {
      print("uidReceive เป็น null");
    }

    if (uidShipping != null) {
      var userShipping =
          await db.collection("user").where('id', isEqualTo: uidShipping).get();

      if (userShipping.docs.isNotEmpty) {
        var userDataShipping = userShipping.docs.toList();
        userDataShipping.map((userMap) {
          latLngShipping = LatLng(
            userMap['latLng']['latitude'],
            userMap['latLng']['longitude'],
          );
        }).toList();
      } else {
        print("ไม่พบข้อมูลผู้ส่ง");
      }
    } else {
      print("uidShipping เป็น null");
    }

    // เรียกใช้ setState เพื่ออัปเดต UI
    setState(() {
      // คุณอาจจะใส่ข้อมูลที่ได้มาในตัวแปรที่เหมาะสม
    });
  }

  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // ตรวจสอบว่าเปิดใช้งานการบริการตำแหน่งหรือไม่
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  // ตรวจสอบและขออนุญาตการเข้าถึงตำแหน่ง
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

  // ดึงตำแหน่งปัจจุบัน โดยใช้ LocationAccuracy.low เพื่อให้ได้ตำแหน่งที่เร็วขึ้น
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.low, // ความแม่นยำต่ำ เพื่อการรับตำแหน่งที่เร็วขึ้น
  );
}

  void updateRiderStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection("rider")
          .doc(userProfile.id.toString())
          .update({
        'status': 'ยังไม่รับงาน',
      });

      // นำไปยังหน้า detailRiderPage
      storage.write('StatusRider', "ยังไม่รับงาน");
      Get.to(() => const MenuRiderPage());

      print("Status updated successfully!");
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  void orderReceive() async {
    log("orderReceive");
    var pathImageReceive;
    if (imageReceive != null) {
      pathImageReceive = await uploadImage(imageReceive!); // ใช้ await เพื่อรอ URL ของภาพ
      log("อัพรูป");
    } else {
      showErrorDialog(
          'ไม่สามารถทำรายการได้', 'คุณยังไม่ได้เพิ่มรูปภาพสินค้า', context);

      return;
    }

    try {
      // อัปเดตสถานะในเอกสารที่มี oid ตรงกัน (Document ID)
      await FirebaseFirestore.instance
          .collection("order")
          .doc(orderid.oid.toString())
          .update({
        'status': 'ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง',
        'image2': pathImageReceive
      });

      print("Status updated successfully!");
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  void orderSeccess() async {
    log("orderSeccess");
    var pathImageSeccess;
    if (imageSeccess != null) {
      pathImageSeccess = await uploadImage(imageReceive!); // ใช้ await เพื่อรอ URL ของภาพ
      log("อัพรูป");
    } else {
      showErrorDialog(
          'ไม่สามารถทำรายการได้', 'คุณยังไม่ได้เพิ่มรูปภาพสินค้า', context);

      return;
    }

    try {
      // อัปเดตสถานะในเอกสารที่มี oid ตรงกัน (Document ID)
      await FirebaseFirestore.instance
          .collection("order")
          .doc(orderid.oid.toString())
          .update(
              {
              'status': 'ไรเดอร์นำส่งสินค้าแล้ว', 
              'image3': pathImageSeccess
              });

      print("Status updated successfully!");
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<String> uploadImage(XFile image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // ใช้ชื่อไฟล์จาก timestamp ที่ไม่ซ้ำกัน
    Reference ref = storage.ref().child("orderimages/$uniqueFileName.jpg");
    UploadTask uploadTask = ref.putFile(File(image.path));

    // รอให้การอัปโหลดเสร็จสิ้นแล้วดึง URL มา
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
