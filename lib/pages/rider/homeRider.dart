import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/rider/detailRider.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class homeRiderPage extends StatefulWidget {
  const homeRiderPage({super.key});

  @override
  State<homeRiderPage> createState() => _homeRiderPageState();
}

class _homeRiderPageState extends State<homeRiderPage> {
  GetStorage storage = GetStorage();
  late Future<void> loadData;
  UserProfile userProfile = UserProfile();
  List<Map<String, dynamic>> orderList = [];
  OrderID orderid = OrderID();
  var db = FirebaseFirestore.instance;
  var statusLoad = "Loading";
  bool isLoading = true;
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  dynamic MyLat = 0.0;
  dynamic MyLng = 0.0;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipRect(
            child: Align(
              heightFactor: 0.8,
              child: Image.asset(
                context.read<Appdata>().imageRiderBg,
                width: double.infinity,
              ),
            ),
          ),
          // Container ที่เป็นวงกลมสีเหลืองทับอยู่บนรูป
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity, // ความกว้างของ Container
              height: 600, // ความสูงของ Container
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5), // สีของ Container
                borderRadius:
                    BorderRadius.vertical(top: Radius.elliptical(200, 50)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: loadData, // ฟังก์ชันที่ดึงข้อมูลจากฐานข้อมูล
                        builder: (context, snapshot) {
                          // ตรวจสอบสถานะการโหลดข้อมูล
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              children: [
                                SizedBox(height: Get.height / 5),
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
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize:
                                          Get.textTheme.headlineSmall!.fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (statusLoad == "Loading") {
                            return Column(
                              children: [
                                SizedBox(height: Get.height / 5),
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            );
                          }
                          // ตรวจสอบว่ามีข้อมูลหรือไม่
                          else if (orderList.isEmpty) {
                            return Column(
                              children: [
                                SizedBox(height: Get.height / 5),
                                Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.boxOpen,
                                    size: Get.height / 10,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        Get.textTheme.headlineSmall!.fontSize!,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ยังไม่มีที่สามารถรับได้',
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: Get
                                            .textTheme.headlineSmall!.fontSize,
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
                                padding: EdgeInsets.only(
                                    top: Get.textTheme.labelSmall!.fontSize!),
                                child: Column(
                                  children: orderList.map((orderlist) {
                                    var userData = orderlist['userData'];
                                    var orderData = orderlist['orderData'];

                                    return buildProfileCard(
                                      userData['id'],
                                      userData['image'],
                                      userData['name'] ??
                                          'ไม่ระบุชื่อ', // ตรวจสอบ null
                                      userData['phone'] ??
                                          'ไม่ระบุเบอร์โทร', // ตรวจสอบ null
                                      orderData['status'],
                                      orderData['oid'],
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> loadDataAsync() async {
    final docRef = db
        .collection("order")
        .where("status", isEqualTo: "รอไรเดอร์มารับสินค้า");

    // ยกเลิก listener ก่อนหน้า
    if (context.read<Appdata>().listener != null) {
      context.read<Appdata>().listener!.cancel();
      context.read<Appdata>().listener = null;
    }

    context.read<Appdata>().listener = docRef.snapshots().listen(
      (orderSnapshot) async {
        if (orderSnapshot.docs.isNotEmpty) {
          orderList.clear(); // เคลียร์ list ก่อนเริ่มเพิ่มใหม่
          var orderDocs = orderSnapshot.docs.toList();

          // ดึง uidReceive จาก order ทั้งหมดที่ได้มา
          var uidReceiveList =
              orderDocs.map((doc) => doc['uidReceive']).toList();

          var uidShippingList =
              orderDocs.map((doc) => doc['uidShipping']).toList();

          // ยกเลิก listener2 ก่อนหน้า
          if (context.read<Appdata>().listener2 != null) {
            context.read<Appdata>().listener2!.cancel();
            context.read<Appdata>().listener2 = null;
          }

          // ใช้ in query เพื่อดึงข้อมูล user ที่มี id ตรงกับ uidReceive
          var userReceiveQuery =
              db.collection("user").where("id", whereIn: uidReceiveList);
          var userShippingQuery =
              db.collection("user").where("id", whereIn: uidShippingList);

          context.read<Appdata>().listener2 =
              userReceiveQuery.snapshots().listen(
            (userSnapshot) async {
              if (userSnapshot.docs.isNotEmpty) {
                orderList.clear(); // ล้างรายการก่อนเพิ่มข้อมูลใหม่

                // สร้างแผนที่เพื่อจับคู่ user id กับข้อมูลผู้ใช้
                var userMap = {
                  for (var userDoc in userSnapshot.docs)
                    userDoc['id']: userDoc.data(),
                };

                // ลูปผ่าน order แต่ละรายการ และผูกข้อมูล user
                for (var orderDoc in orderDocs) {
                  var uidReceive = orderDoc['uidReceive'];

                  var userDataReceive = userMap[
                      uidReceive]; // ดึงข้อมูลผู้ใช้ที่ตรงกับ uidReceive

                  if (userDataReceive != null) {
                    try {
                      var position =
                          await _determinePosition(); // ดึงตำแหน่งปัจจุบัน

                      log(position.toString());

                      //อัพเดตตำแหน่งปัจจุบัน
                      latLng = LatLng(position.latitude, position.longitude);
                      MyLat = position.latitude;
                      MyLng = position.longitude;

                      //isLoading = false; // ตั้งค่าเป็นไม่โหลดเมื่อได้ตำแหน่ง
                    } catch (e) {
                      setState(() {
                        isLoading = false; // ตั้งค่าเป็นไม่โหลด
                      });
                      log('Error: $e');
                    }

                    var ReceiveLat =
                        userDataReceive['latLng']?['latitude'] ?? 0.0;
                    var ReceiveLng =
                        userDataReceive['latLng']?['longitude'] ?? 0.0;

                    var distanceInKm =
                        calculateDistance(MyLat, MyLng, ReceiveLat, ReceiveLng);
                    var distanceInMiles = distanceInKm * 0.621371;
                    var distanceInMetersReceive = distanceInKm * 1000;

                    // ตรวจสอบระยะทาง ถ้าน้อยกว่า 20 เมตรให้แสดง order นั้น
                    if (distanceInMetersReceive <= 300) {
                      orderList.add({
                        'orderData': orderDoc.data(),
                        'userData': userDataReceive,
                      });
                      //log(shippingList.toString());
                    }

                    // แสดงระยะทาง
                    String distanceText = distanceInKm >= 9999
                        ? "${distanceInMiles.toStringAsFixed(2)} ไมล์"
                        : distanceInKm < 1
                            ? "${(distanceInMetersReceive).toInt()} เมตร"
                            : "${distanceInKm.toStringAsFixed(2)} กิโลเมตร";
                    //log(distanceText.toString());
                  }
                }
                statusLoad = "โหลดเสร็จสิ้น";
              } else {
                statusLoad = "โหลดเสร็จสิ้น";
                log("ไม่พบข้อมูลผู้ใช้");
              }

              setState(() {}); // อัปเดต UI
            },
            onError: (error) => log("User listen failed: $error"),
          );

          context.read<Appdata>().listener2 =
              userShippingQuery.snapshots().listen(
            (userSnapshot) async {
              if (userSnapshot.docs.isNotEmpty) {
                orderList.clear(); // ล้างรายการก่อนเพิ่มข้อมูลใหม่

                // สร้างแผนที่เพื่อจับคู่ user id กับข้อมูลผู้ใช้
                var userMap = {
                  for (var userDoc in userSnapshot.docs)
                    userDoc['id']: userDoc.data(),
                };

                // ลูปผ่าน order แต่ละรายการ และผูกข้อมูล user
                for (var orderDoc in orderDocs) {
                  var uidShipping = orderDoc['uidShipping'];

                  var userDataShipping = userMap[
                      uidShipping]; // ดึงข้อมูลผู้ใช้ที่ตรงกับ uidReceive

                  if (userDataShipping != null) {
                    try {
                      var position =
                          await _determinePosition(); // ดึงตำแหน่งปัจจุบัน

                      //อัพเดตตำแหน่งปัจจุบัน
                      latLng = LatLng(position.latitude, position.longitude);
                      MyLat = position.latitude;
                      MyLng = position.longitude;

                      //isLoading = false; // ตั้งค่าเป็นไม่โหลดเมื่อได้ตำแหน่ง
                    } catch (e) {
                      setState(() {
                        isLoading = false; // ตั้งค่าเป็นไม่โหลด
                      });
                      log('Error: $e');
                    }

                    var otherLatShipping =
                        userDataShipping['latLng']?['latitude'] ?? 0.0;
                    var otherLngShipping =
                        userDataShipping['latLng']?['longitude'] ?? 0.0;

                    var distanceInKm = calculateDistance(
                        MyLat, MyLng, otherLatShipping, otherLngShipping);
                    var distanceInMiles = distanceInKm * 0.621371;
                    var distanceInMetersShipping = distanceInKm * 1000;

                    // ตรวจสอบระยะทาง ถ้าน้อยกว่า 20 เมตรให้แสดง order นั้น
                    if (distanceInMetersShipping <= 300) {
                      orderList.add({
                        'orderData': orderDoc.data(),
                        'userData': userDataShipping,
                      });
                    }

                    // แสดงระยะทาง
                    String distanceText = distanceInKm >= 9999
                        ? "${distanceInMiles.toStringAsFixed(2)} ไมล์"
                        : distanceInKm < 1
                            ? "${(distanceInMetersShipping).toInt()} เมตร"
                            : "${distanceInKm.toStringAsFixed(2)} กิโลเมตร";
                    //log(distanceText.toString());
                  }
                }
                statusLoad = "โหลดเสร็จสิ้น";
              } else {
                statusLoad = "โหลดเสร็จสิ้น";
                log("ไม่พบข้อมูลผู้ใช้");
              }

              setState(() {}); // อัปเดต UI
            },
            onError: (error) => log("User listen failed: $error"),
          );
        } else {
          statusLoad = "โหลดเสร็จสิ้น";
          orderList = [];
          log('No documents found in order');
          setState(() {}); // อัปเดต UI เมื่อไม่มีข้อมูล
        }
      },
      onError: (error) => log("Order listen failed: $error"),
    );
  }

  Widget buildProfileCard(int id, String? image, String name,
      String phoneNumber, String status, int oid) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.textTheme.titleMedium!.fontSize!,
          vertical: Get.textTheme.labelSmall!.fontSize!),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Get.textTheme.titleMedium!.fontSize!,
            horizontal: Get.textTheme.titleMedium!.fontSize!),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
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
                      errorBuilder: (context, error, stackTrace) {
                        // ถ้าเกิดข้อผิดพลาดในการโหลดรูปจาก URL
                        return Image.asset(
                          context.read<Appdata>().imageNetworkError,
                          width: Get.height / 9,
                          height: Get.height / 9,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      context.read<Appdata>().imageDefaltUser,
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
            FilledButton(
                onPressed: () async {
                  stopListening();
                  OrderID orderid = OrderID();
                  orderid.oid = oid;
                  storage.write('OrderID', oid);
                  context.read<Appdata>().order = orderid;
                  updateOrderStatus(oid.toString());
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
                child: Text('รับออร์เดอร์',
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

  void updateOrderStatus(String? oid) async {
    // ตรวจสอบว่า oid ไม่เป็น null
    if (oid != null && oid.isNotEmpty) {
      try {
        // อัปเดตสถานะในเอกสารที่มี oid ตรงกัน (Document ID)
        await FirebaseFirestore.instance.collection("order").doc(oid).update({
          'status': 'ไรเดอร์รับงาน',
          'idRider': userProfile.id,
          'latLngRider': {'latitude': MyLat, 'longitude': MyLng},
        });

        await FirebaseFirestore.instance
            .collection("rider")
            .doc(userProfile.id.toString())
            .update({
          'status': 'รับงานแล้ว',
        });
        storage.write('StatusRider', "รับงานแล้ว");
        // นำไปยังหน้า detailRiderPage
        Get.to(() => const detailRiderPage());

        log("Status updated successfully!");
      } catch (e) {
        log('Error updating status: $e');
      }
    } else {
      // แจ้งเตือนกรณีที่ oid เป็น null หรือว่างเปล่า
      log('Error: Order ID (oid) is null or empty');
    }
  }

  // ฟังก์ชันคำนวณระยะทางระหว่างพิกัดสองตำแหน่ง
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // รัศมีของโลกในหน่วยกิโลเมตร

    // Logging ข้อมูลพิกัด
    // dev.log(
    //     'Calculating distance between: Lat1: $lat1, Lon1: $lon1 and Lat2: $lat2, Lon2: $lon2');

    var dLat = _degToRad(lat2 - lat1);
    var dLon = _degToRad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    var distance = R * c; // ระยะทางในหน่วยกิโลเมตร

    // Logging ค่าระยะทางที่คำนวณได้
    //dev.log('Calculated distance: ${distance.toStringAsFixed(2)} KM');

    return distance;
  }

  // ฟังก์ชันแปลงองศาเป็นเรเดียน
  double _degToRad(double deg) {
    return deg * (math.pi / 180);
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
