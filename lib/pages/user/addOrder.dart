import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  TextEditingController detailCtl = TextEditingController();
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;
  ShippingItem shippingItem = ShippingItem();
  UserProfile userProfile = UserProfile();
  var db = FirebaseFirestore.instance;
  StreamSubscription? listener;
  StreamSubscription? listener2;
  var dataShipping;
  var dataReceivce;
  XFile? image;
  var status = "canShipping";
  String txtAddress = "";
  String txtAddress2 = "";

  @override
  void initState() {
    super.initState();
    shippingItem = context.read<Appdata>().shipping;
    userProfile = context.read<Appdata>().user;
    final userShipping = db.collection("user").doc(userProfile.id.toString());
    final userRecivce = db.collection("user").doc(shippingItem.id.toString());
    if (listener != null || listener2 != null) {
      listener!.cancel();
      listener = null;
      listener2!.cancel();
      listener2 = null;
    }
    listener = userShipping.snapshots().listen(
      (event) {
        dataShipping = event.data();
        txtAddress = dataShipping['address'].toString();
        setState(() {});
      },
      onError: (error) => log("Listen failed: $error"),
    );
    listener2 = userRecivce.snapshots().listen(
      (event) {
        dataReceivce = event.data();
        txtAddress2 = dataReceivce['address'].toString();
        setState(() {});
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        listener!.cancel();
        listener = null;
        listener2!.cancel();
        listener2 = null;
      },
      child: Scaffold(
        body: Stack(
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter, // ตัดภาพจากด้านล่าง
                heightFactor: 0.85,
                child: Image.asset(
                  context.read<Appdata>().imageUserBg,
                  width: double.infinity,
                  fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Align(
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
                        height: Get.height / 7,
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
                                    size:
                                        Get.textTheme.headlineLarge!.fontSize!,
                                  ),
                                  SizedBox(
                                      width:
                                          Get.textTheme.labelSmall!.fontSize),
                                  Text(
                                    txtAddress,
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
                                    size:
                                        Get.textTheme.headlineLarge!.fontSize!,
                                  ),
                                  SizedBox(
                                      width:
                                          Get.textTheme.labelSmall!.fontSize),
                                  Text(
                                    txtAddress2,
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
                                chooseOptionUploadDialog();
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
                                chooseOptionUploadDialog();
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
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: Get
                                              .textTheme.titleLarge!.fontSize,
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
                          bottom: Get.textTheme.titleLarge!.fontSize! * 3,
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
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize:
                                        Get.textTheme.titleLarge!.fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF32343E)),
                              ),
                            ),
                            Container(
                              width: Get.width / 1.1,
                              height: Get.height / 7,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(127, 153, 153, 153),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: detailCtl,
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize:
                                        Get.textTheme.titleMedium!.fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                      minimumSize: WidgetStateProperty.all(Size(
                          btnSizeWidth * 5,
                          btnSizeHeight * 1.8)), // กำหนดขนาดของปุ่ม
                      backgroundColor: WidgetStateProperty.all(
                          const Color(0xFFE53935)), // สีพื้นหลังของปุ่ม
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
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

  void chooseOptionUploadDialog() {
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
                    final ImagePicker picker = ImagePicker();
                    image = await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {});
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
                    final ImagePicker picker = ImagePicker();
                    image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      log(image!.path);
                      setState(() {});
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
  // ฟังก์ชันสร้างเลข ID ใหม่จากหมายเลขล่าสุด
  Future<int> generateNewOrderId() async {
    QuerySnapshot querySnapshot = await db
        .collection('order')
        .orderBy('oid', descending: true)
        .limit(1)
        .get(); // ดึงเอกสารล่าสุดตามลำดับตัวเลขที่ลดลง

    if (querySnapshot.docs.isNotEmpty) {
      int lastId = querySnapshot.docs.first['oid'];
      return lastId + 1; // สร้าง OID ใหม่โดยเพิ่ม 1
    } else {
      return 1; // ถ้ายังไม่มีเอกสาร ให้เริ่มที่ 1
    }
  }

  void shippingItemToUser() async {
    showLoadDialog(context);
    if (status != "canShipping") {
      log('กดไปแล้วกดซ้ำไม่ได้ต้องรอก่อน');
      return;
    }
    status = "Shipping";
    int newOrderId = await generateNewOrderId();
    String pathImage;
    if (image != null) {
      pathImage = await uploadImage(image!); // ใช้ await เพื่อรอ URL ของภาพ
    } else {
      Navigator.of(context).pop();
      showErrorDialog(
          'ไม่สามารถทำรายการได้', 'คุณยังไม่ได้เพิ่มรูปภาพสินค้า', context);
      status = "canShipping";
      return;
    }
    var data = {
      'oid': newOrderId, // กำหนดค่าเริ่มต้นหากเป็น null
      'status': "รอไรเดอร์มารับสินค้า",
      'idRider': '',
      'latLngRider': {'latitude': null, 'longitude': null},
      'uidReceive': dataReceivce["id"],
      'uidShipping': dataShipping["id"],
      'detail': detailCtl.text.isNotEmpty ? detailCtl.text : 'no details',
      'image': pathImage ?? '', // ตรวจสอบ image หากเป็น null ให้ใส่ค่าว่าง
      'image2': null,
      'image3': null,
    };

    await db.collection('order').doc(newOrderId.toString()).set(data);
    status = "canShipping";
    Navigator.of(context).pop();
    showCompleteDialgAndBackPage('สำเร็จ', 'ทำรายการเสร็จสิ้น', context);
    log('เพิ่มรายการจัดส่งสำเร็จ, ID: $newOrderId');
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
