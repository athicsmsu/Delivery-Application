import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DetailUserPage extends StatefulWidget {
  const DetailUserPage({super.key});

  @override
  State<DetailUserPage> createState() => _DetailUserPageState();
}

class _DetailUserPageState extends State<DetailUserPage> {
  TextEditingController detailCtl = TextEditingController();
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;
  ShippingItem shippingItem = ShippingItem();
  UserProfile userProfile = UserProfile();
  var db = FirebaseFirestore.instance;
  late StreamSubscription listener;
  late StreamSubscription listener2;
  var dataShipping;
  var dataRecivce;
  XFile? image;

  @override
  void initState() {
    super.initState();
    shippingItem = context.read<Appdata>().shipping;
    final docRef = db.collection("user").doc(userProfile.id.toString());
    final userRecivce = db.collection("user").doc(shippingItem.id.toString());
    listener = docRef.snapshots().listen(
      (event) {
        dataShipping = event.data();
        setState(() {});
      },
      onError: (error) => log("Listen failed: $error"),
    );
    listener2 = userRecivce.snapshots().listen(
      (event) {
        dataRecivce = event.data();
        setState(() {});
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        listener.cancel();
      },
      child: Scaffold(
        body: Stack(
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter, // ตัดภาพจากด้านล่าง
                heightFactor: 0.85,
                child: Image.asset(
                  'assets/images/UserBg.jpg',
                  width: double.infinity,
                  fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity, // ความกว้างของ Container
                height: Get.height / 1.35, // ความสูงของ Container
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5), // สีของ Container
                  borderRadius:
                      BorderRadius.vertical(top: Radius.elliptical(200, 50)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: Get.width / 1.2,
                      height: Get.height / 6,
                      decoration: BoxDecoration(
                        color: Colors.white, // สีพื้นหลังของ Container
                        border: Border.all(
                            color: Colors.black, width: 1), // ขอบสีดำ
                        borderRadius: BorderRadius.circular(20), // โค้งขอบ
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: Get.textTheme.headlineLarge!.fontSize!),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_sharp,
                                  size: Get.textTheme.headlineLarge!.fontSize!,
                                ),
                                SizedBox(
                                    width: Get.textTheme.labelSmall!.fontSize),
                                Text(
                                  dataShipping["address"],
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize:
                                          Get.textTheme.titleLarge!.fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF32343E)),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey, // สีของเส้น
                            thickness: 2, // ความหนาของเส้น
                            indent: Get.textTheme.headlineSmall!
                                .fontSize!, // ระยะห่างจากด้านซ้าย
                            endIndent: Get.textTheme.headlineSmall!
                                .fontSize!, // ระยะห่างจากด้านขวา
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: Get.textTheme.headlineLarge!.fontSize!),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: Get.textTheme.headlineLarge!.fontSize!,
                                ),
                                SizedBox(
                                    width: Get.textTheme.labelSmall!.fontSize),
                                Text(
                                  dataRecivce["address"],
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize:
                                          Get.textTheme.titleLarge!.fontSize,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF32343E)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    (image != null)
                        ? GestureDetector(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                log(image!.path);
                                setState(() {});
                              }
                            },
                            child: Image.file(
                              File(image!.path),
                              width: Get.height / 5, // กำหนดความกว้างของรูป
                              height: Get.height / 5, // กำหนดความสูงของรูป
                              fit: BoxFit.cover,
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                log(image!.path);
                                setState(() {});
                              }
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
                                width: Get.width / 1.2,
                                height: Get.height / 15,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons
                                          .camera_alt_outlined, // เปลี่ยนเป็นไอคอนที่ต้องการ
                                      size:
                                          Get.textTheme.titleLarge!.fontSize! *
                                              1.5, // ขนาดของไอคอน
                                      color:
                                          const Color(0xFF444444), // สีของไอคอน
                                    ),
                                    SizedBox(
                                        width: Get.textTheme.titleLarge!
                                            .fontSize!), // ระยะห่างระหว่างไอคอนและข้อความ
                                    Text(
                                      "เพิ่มรูปภาพ (จำเป็น)", // ข้อความที่ต้องการแสดง
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize:
                                            Get.textTheme.titleLarge!.fontSize,
                                        color: const Color(
                                            0xFF444444), // สีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Get.textTheme.titleLarge!.fontSize!,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: Get.textTheme.titleSmall!.fontSize!),
                            child: Text(
                              "รายละเอียดสินค้า",
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: Get.textTheme.titleLarge!.fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF32343E)),
                            ),
                          ),
                          Container(
                            width: Get.width / 1.1,
                            height: Get.height / 5,
                            decoration: BoxDecoration(
                              color: Colors.white, // สีพื้นหลังของ Container
                              border: Border.all(
                                color: const Color.fromARGB(127, 153, 153, 153),
                                width: 1, // ขอบสี
                              ),
                              borderRadius:
                                  BorderRadius.circular(12), // โค้งขอบ
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // เพิ่ม Padding ให้ TextField
                              child: TextField(
                                controller: detailCtl,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: Get.textTheme.titleMedium!.fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder
                                      .none, // เอาเส้นขอบของ TextField ออก
                                ),
                                maxLines:
                                    null, // ให้ TextField ขยายหลายบรรทัดได้ถ้าจำเป็น
                                keyboardType: TextInputType
                                    .multiline, // เปลี่ยนเป็นโหมดหลายบรรทัด
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: Get.textTheme.titleMedium!.fontSize!,
                    left: Get.textTheme.titleMedium!.fontSize!,
                    right: Get.textTheme.titleMedium!.fontSize!),
                child: FilledButton(
                    onPressed: () {
                      shippingItemToUser();
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(
                          btnSizeWidth * 5,
                          btnSizeHeight * 1.8)), // กำหนดขนาดของปุ่ม
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xFFE53935)), // สีพื้นหลังของปุ่ม
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                      )),
                    ),
                    child: Text('ยืนยัน',
                        style: TextStyle(
                          fontSize: Get.textTheme.titleLarge!.fontSize,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
                        ))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างเลข ID ใหม่จากหมายเลขล่าสุด
  Future<int> generateNewOrderId() async {
    QuerySnapshot querySnapshot = await db
        .collection('order')
        .orderBy('id', descending: true)
        .limit(1)
        .get(); // ดึงเอกสารล่าสุดตามลำดับตัวเลขที่ลดลง

    if (querySnapshot.docs.isNotEmpty) {
      int lastId = querySnapshot.docs.first['id']; 
      return lastId + 1; // สร้าง OID ใหม่โดยเพิ่ม 1
    } else {
      return 1; // ถ้ายังไม่มีเอกสาร ให้เริ่มที่ 1
    }
  }

  void shippingItemToUser() async {
    int newOrderId =
        await generateNewOrderId();

    var data = {
      'oid': newOrderId,
      'status': "รอไรเดอร์มารับสินค้า",
      'uidReceive': dataRecivce["id"],
      'uidShipping': dataShipping["id"],
      'detail': detailCtl.text,
      'image': image?.path,
      'image2': null,
      'image3': null,
      'image4': null
      // 'createAt': DateTime.timestamp()
    };

    await db
        .collection('order')
        .doc(newOrderId.toString())
        .set(data);
    log('เพิ่มรายการจัดส่งสำเร็จ, ID: $newOrderId');
  }
}
