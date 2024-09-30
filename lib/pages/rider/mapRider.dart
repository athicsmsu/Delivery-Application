import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/rider/menuRider.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class mapRiderPage extends StatefulWidget {
  const mapRiderPage({super.key});

  @override
  State<mapRiderPage> createState() => _mapRiderPageState();
}

class _mapRiderPageState extends State<mapRiderPage> {
  XFile? image;
  var status = "canShipping";
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [

            Container(
              color: Colors.lightBlueAccent,
              width: 350,
              height: 300,
              child: Center(child: Text("Map")),
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ถ่ายรูปสินค้าที่ได้รับ"),
                SizedBox(height: 16.0),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  color: Colors.black,
                  strokeWidth: 2,
                  dashPattern: [6, 3], // ความยาวของเส้นและช่องว่าง
                  child: Container(
                    width: 350,
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined, // เปลี่ยนเป็นไอคอนที่ต้องการ
                          size: 24.0, // ขนาดของไอคอน
                          color: Colors.black, // สีของไอคอน
                        ),
                        SizedBox(width: 8.0), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "เพิ่มรูปภาพ (จำเป็น)", // ข้อความที่ต้องการแสดง
                          style: TextStyle(
                            fontSize: 16.0, // ขนาดฟอนต์
                            color: Colors.black, // สีข้อความ
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF56DA40)),
                      minimumSize: MaterialStateProperty.all(Size(350, 60)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                      )),
                    ),
                    child: Text("ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง")),
              ],
            ),
                SizedBox(height: 25.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ถ่ายรูปสินค้าที่จัดส่งแล้ว"),
                SizedBox(height: 16.0),
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
                SizedBox(height: 16.0),
                FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF56DA40)),
                      minimumSize: MaterialStateProperty.all(Size(350, 60)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                      )),
                    ),
                    child: Text("ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง")),
              ],
            ),
                SizedBox(height: 16.0),
            FilledButton(
                onPressed: () {
                  log("เสร็จสิ้น");
                   Get.to(() => const MenuRiderPage());
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFFF7622)),
                  minimumSize: MaterialStateProperty.all(Size(400, 50)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
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
        ),
      ),
    );
  }

    void shippingItemToUser() async {
    showLoadDialog(context);
    if (status != "canShipping") {
      log('กดไปแล้วกดซ้ำไม่ได้ต้องรอก่อน');
      return;
    }
    status = "Shipping";
    var pathImage;
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
      //'oid': , // กำหนดค่าเริ่มต้นหากเป็น null
      'status': "รอไรเดอร์มารับสินค้า",
      'idRider': '',
      'latLngRider': {'latitude': null, 'longitude': null},
      // 'uidReceive': dataReceivce["id"],
      // 'uidShipping': dataShipping["id"],
      // 'detail': detailCtl.text.isNotEmpty ? detailCtl.text : 'no details',
      'image': pathImage ?? '', // ตรวจสอบ image หากเป็น null ให้ใส่ค่าว่าง
      'image2': null,
      'image3': null,
    };

    await db.collection('order').doc(1.toString()).set(data);
    status = "canShipping";
    Navigator.of(context).pop();
    showCompleteDialgAndBackPage('สำเร็จ', 'ทำรายการเสร็จสิ้น', context);
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
