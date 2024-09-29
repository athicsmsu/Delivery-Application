import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/map/SelectMap.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController addressCtl = TextEditingController();
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;
  var imageSize = Get.height / 6;
  XFile? image;
  var db = FirebaseFirestore.instance;

  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  @override
  void initState() {
    super.initState();
    log(latLng.toString());
    latLng = context.read<Appdata>().latLng;
    log(latLng.toString());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        LatLng latLngDemo = const LatLng(0.0, 0.0);
        context.read<Appdata>().latLng = latLngDemo;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          title: Text(
            'Sign up',
            style: TextStyle(
              fontSize: Get.textTheme.titleLarge!.fontSize,
              color: Colors.black,
              fontFamily: GoogleFonts.poppins().fontFamily,
              // letterSpacing: 1
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.textTheme.titleLarge!.fontSize!),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        log(image!.path);
                        setState(() {});
                      }
                    },
                    child: SizedBox(
                      width: imageSize, // กำหนดความกว้าง
                      height: imageSize,
                      child: Stack(
                        children: [
                          Container(
                            width: imageSize, // กำหนดความกว้าง
                            height: imageSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFA0A0), // สีของกรอบ
                                width: 10, // ความหนาของกรอบ
                              ),
                            ),
                            child: ClipOval(
                              child: (image != null)
                                  ? Image.file(
                                      File(image!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/images/RegisterDemo.jpg",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: Get.textTheme.displayMedium!
                                  .fontSize!, // กำหนดความกว้างของวงกลมเล็ก
                              height: Get.textTheme.displayMedium!
                                  .fontSize!, // กำหนดความสูงของวงกลมเล็ก
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xFFE53935), // สีพื้นหลังของวงกลมเล็ก
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                      0xFFE53935), // สีของกรอบวงกลมเล็ก
                                  width: 2.5, // ความหนาของกรอบวงกลมเล็ก
                                ),
                              ),
                              child: Icon(
                                Icons.edit, // ไอคอนที่จะแสดงในวงกลมเล็ก
                                color: Colors.white, // สีของไอคอน
                                size: Get.textTheme.displaySmall!
                                    .fontSize!, // ขนาดของไอคอน
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.textTheme.labelSmall!.fontSize!),
                        child: Text(
                          'ชื่อ',
                          style: TextStyle(
                            fontSize: Get.textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            // letterSpacing: 1
                          ),
                        ),
                      ),
                      TextField(
                        controller: nameCtl,
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: Get.textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEBEBEB),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.textTheme.labelSmall!.fontSize!),
                        child: Text(
                          'เบอร์โทร',
                          style: TextStyle(
                            fontSize: Get.textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            // letterSpacing: 1
                          ),
                        ),
                      ),
                      TextField(
                        controller: phoneCtl,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: Get.textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEBEBEB),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                              10), // จำกัดตัวเลขที่ป้อนได้สูงสุด 10 ตัว
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.textTheme.labelSmall!.fontSize!),
                        child: Text(
                          'รหัสผ่าน',
                          style: TextStyle(
                            fontSize: Get.textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            // letterSpacing: 1
                          ),
                        ),
                      ),
                      TextField(
                        controller: passwordCtl,
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: Get.textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEBEBEB),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.textTheme.labelSmall!.fontSize!),
                        child: Text(
                          'ที่อยู่',
                          style: TextStyle(
                            fontSize: Get.textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            // letterSpacing: 1
                          ),
                        ),
                      ),
                      TextField(
                        controller: addressCtl,
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: Get.textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEBEBEB),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.textTheme.titleSmall!.fontSize!),
                        child: FilledButton(
                            onPressed: () => map(),
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(Size(
                                  btnSizeWidth * 5,
                                  btnSizeHeight * 1.8)), // กำหนดขนาดของปุ่ม
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFFFF7622)), // สีพื้นหลังของปุ่ม
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12.0), // ทำให้ขอบมน
                              )),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('ปักหมุดที่อยู่ของคุณ',
                                    style: TextStyle(
                                      fontSize:
                                          Get.textTheme.titleLarge!.fontSize,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFFFFFF),
                                    )),
                                Icon(
                                  Icons
                                      .location_on_sharp, // ไอคอนที่จะแสดงในวงกลมเล็ก
                                  color: Colors.white, // สีของไอคอน
                                  size: Get.textTheme.displaySmall!
                                      .fontSize!, // ขนาดของไอคอน
                                ),
                              ],
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Get.textTheme.titleMedium!.fontSize!,
                            left: Get.textTheme.titleMedium!.fontSize!,
                            right: Get.textTheme.titleMedium!.fontSize!),
                        child: FilledButton(
                            onPressed: () => dialogRegister(),
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(Size(
                                  btnSizeWidth * 5,
                                  btnSizeHeight * 1.8)), // กำหนดขนาดของปุ่ม
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFFE53935)), // สีพื้นหลังของปุ่ม
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12.0), // ทำให้ขอบมน
                              )),
                            ),
                            child: Text('SIGN UP',
                                style: TextStyle(
                                  fontSize: Get.textTheme.titleLarge!.fontSize,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFFFFFF),
                                ))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// ฟังก์ชันสำหรับ hash รหัสผ่าน
  String hashPassword(String password) {
    var bytes = utf8.encode(password); // แปลงรหัสผ่านเป็น byte
    var digest = sha256.convert(bytes); // ทำการ hash ด้วย SHA-256
    return digest.toString(); // คืนค่า hash ในรูปแบบ string
  }

// ฟังก์ชันสร้างเลข ID ใหม่จากหมายเลขล่าสุด
  Future<int> generateNewUserId() async {
    QuerySnapshot querySnapshot = await db
        .collection('user')
        .orderBy('id', descending: true)
        .limit(1)
        .get(); // ดึงเอกสารล่าสุดตามลำดับตัวเลขที่ลดลง

    if (querySnapshot.docs.isNotEmpty) {
      int lastId = querySnapshot.docs.first['id']; // ดึง ID ล่าสุดจากเอกสาร
      return lastId + 1; // สร้าง ID ใหม่โดยเพิ่ม 1
    } else {
      return 1; // ถ้ายังไม่มีเอกสาร ให้เริ่มที่ 1
    }
  }

// ฟังก์ชันสำหรับสมัครสมาชิก
  Future<void> registerNewUser() async {
    int newUserId = await generateNewUserId(); // เรียกใช้ฟังก์ชันสร้างเลข ID
    var pathImage;
    if (image != null) {
      pathImage = await uploadImage(image!); // ใช้ await เพื่อรอ URL ของภาพ
    } else {
      pathImage = null; // ใช้ภาพที่มีอยู่แล้วถ้าไม่ได้เปลี่ยน
    }
    var data = {
      'id': newUserId, // เก็บ ID ใหม่ลงในเอกสาร
      'name': nameCtl.text,
      'phone': phoneCtl.text,
      'password': hashPassword(passwordCtl.text),
      'address': addressCtl.text,
      'latLng': {'latitude': latLng.latitude, 'longitude': latLng.longitude},
      'image': pathImage
      // 'createAt': DateTime.timestamp()
    };

    await db
        .collection('user')
        .doc(newUserId.toString())
        .set(data); // ใช้ ID เป็น document ID
    log('สมัครสมาชิกสำเร็จ, ID: $newUserId');
  }

  void register() async {
    await registerNewUser();
    Navigator.of(context).pop();
    showRegisterCompleteDialog(context);
  }

  Future<void> dialogRegister() async {
    latLng = context.read<Appdata>().latLng;
    // ตรวจสอบว่ามีช่องว่างหรือไม่
    if (nameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        passwordCtl.text.isEmpty ||
        addressCtl.text.isEmpty) {
      showErrorDialog('ผิดพลาด', 'คุณกรอกข้อมูลไม่ครบ', context);
    }
    // ตรวจสอบรูปแบบหมายเลขโทรศัพท์
    else if (phoneCtl.text.length < 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phoneCtl.text)) {
          showErrorDialog('ผิดพลาด', 'หมายเลขโทรศัพท์ของคุณไม่ถูกต้อง', context);
    }
    // ตรวจสอบชื่อผู้ใช้
    else if (nameCtl.text.trim().isEmpty) {
      showErrorDialog('ผิดพลาด', 'ชื่อผู้ใช้ของคุณไม่ถูกต้อง', context);
    }
    // ตรวจสอบที่อยู่
    else if (addressCtl.text.trim().isEmpty) {
      showErrorDialog('ผิดพลาด', 'ที่อยู่ของคุณไม่ถูกต้อง', context);
    }
    // ตรวจสอบการปักหมุด
    else if (latLng.latitude == 0.0 && latLng.longitude == 0.0) {
      showErrorDialog('ผิดพลาด', 'คุณยังไม่ได้ปักหมุดที่อยู่', context);
    }
    // ตรวจสอบว่าหมายเลขโทรศัพท์ซ้ำหรือไม่
    else {
      showLoadDialog(context);
      QuerySnapshot querySnapshot = await db
          .collection('user')
          .where('phone', isEqualTo: phoneCtl.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // ถ้าพบหมายเลขโทรศัพท์ซ้ำ
        Navigator.of(context).pop();
        showErrorDialog('ผิดพลาด', 'หมายเลขโทรศัพท์นี้ถูกใช้ไปแล้ว', context);
      } else {
        // ถ้าไม่มีหมายเลขโทรศัพท์ซ้ำ ให้ดำเนินการต่อไป
        register(); // ฟังก์ชันสมัครสมาชิกใหม่
      }
    }
  }

  Future<String> uploadImage(XFile image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // ใช้ชื่อไฟล์จาก timestamp ที่ไม่ซ้ำกัน
    Reference ref = storage.ref().child("images/$uniqueFileName.jpg");
    UploadTask uploadTask = ref.putFile(File(image.path));

    // รอให้การอัปโหลดเสร็จสิ้นแล้วดึง URL มา
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  map() {
    Get.to(() => const SelectMapPage());
  }
}
