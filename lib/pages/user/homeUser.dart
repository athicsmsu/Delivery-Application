import 'dart:math' as math;
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/user/addOrder.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  TextEditingController searchCtl = TextEditingController();
  List<Map<String, dynamic>> SearchList = []; // ลิสต์สำหรับเก็บรายการค้นหา
  late Future<void> loadData;
  var searchStatus = "ยังไม่ค้นหา";
  var db = FirebaseFirestore.instance;
  var Mydata;
  String? myPhone;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.85,
              child: Image.asset(
                context.read<Appdata>().imageUserBg,
                width: double.infinity,
                fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: Get.height / 1.5,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius:
                    BorderRadius.vertical(top: Radius.elliptical(200, 50)),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(top: Get.textTheme.displaySmall!.fontSize!),
                child: Column(
                  children: [
                    SizedBox(
                      width: Get.width - 50,
                      child: TextField(
                        controller: searchCtl,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: Get.textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                        decoration: InputDecoration(
                          hintText: 'ค้นหาจากหมายเลขโทรศัพท์',
                          filled: true,
                          fillColor: const Color(0xFFEBEBEB),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                if (searchCtl.text.isNotEmpty) {
                                  searchStatus = "ค้นหาแล้ว";
                                } else {
                                  dev.log("Empty");
                                  return;
                                }
                                dev.log(searchStatus);
                                Search();
                              },
                              child: const Icon(Icons.search)),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                              10), // จำกัดตัวเลขที่ป้อนได้สูงสุด 10 ตัว
                        ],
                      ),
                    ),
                    SizedBox(height: Get.textTheme.titleMedium!.fontSize),
                    Padding(
                      padding:  EdgeInsets.only(left: Get.textTheme.titleLarge!.fontSize!),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FilledButton(
                              onPressed: () {
                                SearchAllUser();
                              },
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all(Size(
                                    Get.width / 2.5,
                                    Get.textTheme.titleMedium!.fontSize! *
                                        3)), // กำหนดขนาดของปุ่ม
                                backgroundColor: WidgetStateProperty.all(
                                    const Color(0xFF56DA40)), // สีพื้นหลังของปุ่ม
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8.0), // ทำให้ขอบมน
                                )),
                              ),
                              child: Text('ผู้ใช้ทั้งหมด',
                                  style: TextStyle(
                                    fontSize: Get.textTheme.titleSmall!.fontSize,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFFFFFF),
                                  ))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: loadData,
                        builder: (context, snapshot) {
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
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  SizedBox(height: Get.height / 10),
                                  SizedBox(
                                    height: Get.height / 7,
                                    width: Get.width / 3.5,
                                    child: ClipOval(
                                        child: Image.asset(
                                      height: Get.height,
                                      width: Get.width,
                                      context.read<Appdata>().Error404,
                                      fit: BoxFit.cover,
                                    )),
                                  ),
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
                          } else if (searchStatus == "ยังไม่ค้นหา") {
                            return Column(
                              children: [
                                SizedBox(height: Get.height / 10),
                                SizedBox(
                                  height: Get.height / 7,
                                  width: Get.width / 3.5,
                                  child: ClipOval(
                                      child: Image.asset(
                                    height: Get.height,
                                    width: Get.width,
                                    context.read<Appdata>().SearchUser,
                                    fit: BoxFit.cover,
                                  )),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        Get.textTheme.headlineSmall!.fontSize!,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ค้นหาคนที่คุณจะส่งสินค้าสิ',
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
                          } else if (SearchList.isEmpty) {
                            return Column(
                              children: [
                                SizedBox(height: Get.height / 10),
                                Center(
                                    child: Image.asset(
                                  context.read<Appdata>().imageUserNotFound,
                                  height: Get.height / 5,
                                  width: Get.width / 3.5,
                                  fit: BoxFit.cover,
                                )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        Get.textTheme.headlineSmall!.fontSize!,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ไม่พบผู้ใช้',
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
                              child: Column(
                                children: SearchList.map((users) {
                                  // ค่า latLng ของผู้ใช้ปัจจุบัน
                                  var MyLat = Mydata['latLng']['latitude'];
                                  var MyLng = Mydata['latLng']['longitude'];

                                  // ค่า latLng ของผู้ใช้ที่ต้องการเปรียบเทียบ
                                  var otherLat = users['latLng']['latitude'];
                                  var otherLng = users['latLng']['longitude'];

                                  // คำนวณระยะทางเป็นกิโลเมตร
                                  var distanceInKm = calculateDistance(
                                      MyLat, MyLng, otherLat, otherLng);
                                  // คำนวณระยะทางเป็นไมล์
                                  var distanceInMiles = distanceInKm * 0.621371;

                                  // ตรวจสอบระยะทาง
                                  String distanceText;
                                  if (distanceInKm >= 9999) {
                                    // ถ้าระยะทางถึง 9999 กิโลเมตร
                                    distanceText =
                                        "${distanceInMiles.toStringAsFixed(2)}  ไมล์";
                                  } else if (distanceInKm < 1) {
                                    // ถ้าระยะทางน้อยกว่า 1 กิโลเมตร แสดงเป็นเมตร
                                    var distanceInMeters = (distanceInKm * 1000)
                                        .toInt(); // แปลงเป็นเมตรและทำให้เป็นจำนวนเต็ม
                                    distanceText = "$distanceInMeters  เมตร";
                                  } else {
                                    distanceText =
                                        "${distanceInKm.toStringAsFixed(2)}  กิโลเมตร";
                                  }
                                  // คำนวณค่าจัดส่ง: 1 กิโลเมตร = 10 บาท
                                  var shippingCost =
                                      calculateShippingCost(distanceInKm);
                                  return buildProfileCard(
                                    users["id"],
                                    users["image"],
                                    users["name"],
                                    users["address"],
                                    distanceText, // แสดงระยะทางตามหน่วยที่เหมาะสม
                                    "$shippingCost  บาท",
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
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
    // dev.log('Calculated distance: ${distance.toStringAsFixed(2)} KM');

    return distance;
  }

// ฟังก์ชันแปลงองศาเป็นเรเดียน
  double _degToRad(double deg) {
    return deg * (math.pi / 180);
  }

  Future<void> loadDataAsync() async {
    if (context.read<Appdata>().listener != null) {
      context.read<Appdata>().listener!.cancel();
      context.read<Appdata>().listener = null;
      dev.log('stop old listener');
    }
    if (context.read<Appdata>().listener2 != null) {
      context.read<Appdata>().listener2!.cancel();
      context.read<Appdata>().listener2 = null;
      dev.log('stop old listener2');
    }
    var query = await db
        .collection('user')
        .where('id', isEqualTo: context.read<Appdata>().user.id);

    context.read<Appdata>().listener = query.snapshots().listen(
      (querySnapshot) async {
        var user = await query.get();
        // ตรวจสอบว่ามีผลลัพธ์หรือไม่
        if (user.docs.isNotEmpty) {
          myPhone = querySnapshot.docs.first['phone']; // ดึงข้อมูล phone
          Mydata = querySnapshot.docs.first;
        } else {
          dev.log("No user found.");
        }
        setState(() {});
      },
      onError: (error) => dev.log("Listen failed: $error"),
    );

    setState(() {});
  }

  SearchAllUser() async{
    if (myPhone == null) {
      dev.log('message');
      return;
    }
    showLoadDialog(context);
    var query = await db.collection('user').where("phone", isNotEqualTo: myPhone);
    context.read<Appdata>().listener2 = await query.snapshots().listen(
      (querySnapshot) async {
        var result = await query.get();
        // ตรวจสอบว่ามีผลลัพธ์หรือไม่
        if (result.docs.isNotEmpty) {
          SearchList = [];
          for (var i = result.docs.length; i > 0; i--) {
            SearchList.add(result.docs[i-1]
                .data()); // เพิ่มข้อมูลทั้งเอกสารในรูปแบบของ Map<String, dynamic>
          }
          searchStatus = "ค้นหาแล้ว";
        } else {
          searchStatus = "ค้นหาแล้ว";
          SearchList = [];
          dev.log("No matching phone number found.");
        }
        setState(() {}); // อัปเดต UI
      },
      onError: (error) => dev.log("Listen failed: $error"),
    );
    Navigator.of(context).pop();
  }

  void Search() async {
    showLoadDialog(context);
    if (searchCtl.text.isEmpty) {
      SearchList = [];
      Navigator.of(context).pop();
      setState(() {});
      return;
    } else if (searchCtl.text == myPhone) {
      SearchList = [];
      Navigator.of(context).pop();
      setState(() {});
      return;
    }

    // อ้างอิงไปยัง collection 'user'
    var collecUser = db.collection("user");
    QuerySnapshot querySnapshot =
        await db.collection('user').where("phone", isNotEqualTo: myPhone).get();
    var phoneMatchFound = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> resultDoc = doc.data() as Map<String, dynamic>;
      if (resultDoc["phone"].toString().contains(searchCtl.text)) {
        // dev.log(resultDoc["phone"]);
        phoneMatchFound.add(resultDoc["phone"]);
      }
    }

    if (phoneMatchFound.isEmpty) {
      SearchList = [];
      dev.log("No matching phone number found.");
      Navigator.of(context).pop();
      setState(() {}); // อัปเดต UI
      return;
    }

    // ทำการ query หาข้อมูลที่เบอร์โทรตรงกับสิ่งที่พิมพ์
    for (var i = 0; i < phoneMatchFound.length; i++) {
      dev.log(phoneMatchFound.toString());
    }
    var query = collecUser.where("phone", whereIn: phoneMatchFound);

    context.read<Appdata>().listener2 = await query.snapshots().listen(
      (querySnapshot) async {
        var result = await query.get();
        // ตรวจสอบว่ามีผลลัพธ์หรือไม่
        if (result.docs.isNotEmpty) {
          SearchList = [];
          // ลูปผ่านผลลัพธ์แล้วเพิ่มเข้าไปใน SearchList เป็น Map<String, dynamic>
          for (var doc in result.docs) {
            SearchList.add(doc
                .data()); // เพิ่มข้อมูลทั้งเอกสารในรูปแบบของ Map<String, dynamic>
          }
        } else {
          searchStatus = "ค้นหาแล้ว";
          SearchList = [];
          dev.log("No matching phone number found.");
        }
        setState(() {}); // อัปเดต UI
      },
      onError: (error) => dev.log("Listen failed: $error"),
    );
    // อัปเดต UI
    Navigator.of(context).pop();
  }

  // ฟังก์ชันสร้างการ์ดโปรไฟล์
  Widget buildProfileCard(int id, String? image, String name, String address,
      String distance, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.textTheme.titleMedium!.fontSize!,
          vertical: Get.textTheme.labelSmall!.fontSize!),
      child: Container(
        height: Get.height / 2,
        padding: EdgeInsets.symmetric(
            vertical: Get.textTheme.titleMedium!.fontSize!,
            horizontal: Get.textTheme.titleMedium!.fontSize!),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          border: Border.all(
              color: const Color.fromARGB(127, 153, 153, 153), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipOval(
              child: (image != null && image.isNotEmpty)
                  ? Image.network(
                      image,
                      width: Get.height / 4.5,
                      height: Get.height / 4.5,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // ถ้าเกิดข้อผิดพลาดในการโหลดรูปจาก URL
                        return Image.asset(
                          context.read<Appdata>().imageNetworkError,
                          width: Get.height / 4.5,
                          height: Get.height / 4.5,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      context.read<Appdata>().imageDefaltUser,
                      width: Get.height / 4.5,
                      height: Get.height / 4.5,
                      fit: BoxFit.cover,
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      fontSize: Get.textTheme.titleLarge!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                    )),
                Text('ที่อยู่จัดส่ง : $address',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                    )),
                SizedBox(height: Get.textTheme.titleSmall!.fontSize),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ระยะทาง",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleSmall!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF747783),
                            )),
                        Text("ค่าจัดส่ง",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleSmall!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF747783),
                            )),
                      ],
                    ),
                    SizedBox(width: Get.textTheme.titleSmall!.fontSize!),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(distance,
                            style: TextStyle(
                              fontSize: Get.textTheme.titleSmall!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF747783),
                            )),
                        Text(price,
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
              ],
            ),
            FilledButton(
                onPressed: () {
                  ShippingItem shippingId = ShippingItem();
                  shippingId.id = id;
                  //int id
                  context.read<Appdata>().shipping = shippingId;
                  Get.to(() => const AddOrderPage());
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size(
                      Get.width,
                      Get.textTheme.titleMedium!.fontSize! *
                          3)), // กำหนดขนาดของปุ่ม
                  backgroundColor: WidgetStateProperty.all(
                      const Color(0xFFFF7622)), // สีพื้นหลังของปุ่ม
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // ทำให้ขอบมน
                  )),
                ),
                child: Text('เลือก',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF),
                    ))),
          ],
        ),
      ),
    );
  }
}
