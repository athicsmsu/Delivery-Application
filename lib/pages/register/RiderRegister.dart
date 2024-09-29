import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart';

class RiderRegisterPage extends StatefulWidget {
  const RiderRegisterPage({super.key});

  @override
  State<RiderRegisterPage> createState() => _RiderRegisterPageState();
}

class _RiderRegisterPageState extends State<RiderRegisterPage> {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController numCarCtl = TextEditingController();
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;
  var imageSize = Get.height / 6;
  XFile? image;
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: GestureDetector(
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
                                      // width: 160, // กำหนดความกว้างของรูปภาพ
                                      // height: 160, // กำหนดความสูงของรูปภาพ
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
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Get.textTheme.titleSmall!.fontSize!),
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
                          vertical: Get.textTheme.titleSmall!.fontSize!),
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
                          vertical: Get.textTheme.titleSmall!.fontSize!),
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
                          vertical: Get.textTheme.titleSmall!.fontSize!),
                      child: Text(
                        'ทะเบียนรถ',
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
                      controller: numCarCtl,
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
                          horizontal: Get.textTheme.titleMedium!.fontSize!,
                          vertical: Get.textTheme.titleLarge!.fontSize!),
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
    );
  }

  dialogRegister() async {
    if (nameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        passwordCtl.text.isEmpty ||
        numCarCtl.text.isEmpty) {
           showErrorDialog('ผิดพลาด', 'คุณกรอกข้อมูลไม่ครบ', context);
    } else if (phoneCtl.text.length < 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phoneCtl.text)) {
           showErrorDialog('ผิดพลาด', 'หมายเลขโทรศัพท์ของคุณไม่ถูกต้อง', context);
    } else if (nameCtl.text.trim().isEmpty) {
       showErrorDialog('ผิดพลาด', 'ชื่อผู้ใช้ของคุณไม่ถูกต้อง', context);
    } else if (numCarCtl.text.trim().isEmpty) {
       showErrorDialog('ผิดพลาด', 'ทะเบียนรถของคุณไม่ถูกต้อง', context);
    }
    // ตรวจสอบว่าหมายเลขโทรศัพท์ซ้ำหรือไม่
    else {
      dialogLoad(context);
      QuerySnapshot querySnapshot = await db
          .collection('rider')
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

// ฟังก์ชันสำหรับ hash รหัสผ่าน
  String hashPassword(String password) {
    var bytes = utf8.encode(password); // แปลงรหัสผ่านเป็น byte
    var digest = sha256.convert(bytes); // ทำการ hash ด้วย SHA-256
    return digest.toString(); // คืนค่า hash ในรูปแบบ string
  }

// ฟังก์ชันสร้างเลข ID ใหม่จากหมายเลขล่าสุด
  Future<int> generateNewRiderId() async {
    QuerySnapshot querySnapshot = await db
        .collection('rider')
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
  Future<void> registerNewRider() async {
    int newRiderId = await generateNewRiderId(); // เรียกใช้ฟังก์ชันสร้างเลข ID
    var pathImage;
    if (image != null) {
      pathImage = await uploadImage(image!); // ใช้ await เพื่อรอ URL ของภาพ
    } else {
      pathImage = null; // ใช้ภาพที่มีอยู่แล้วถ้าไม่ได้เปลี่ยน
    }
    var data = {
      'id': newRiderId, // เก็บ ID ใหม่ลงในเอกสาร
      'name': nameCtl.text,
      'phone': phoneCtl.text,
      'password': hashPassword(passwordCtl.text),
      'numCar': numCarCtl.text,
      'image': pathImage,
      'status': "ยังไม่รับงาน"
    };

    await db
        .collection('rider')
        .doc(newRiderId.toString())
        .set(data); // ใช้ ID เป็น document ID
    log('สมัครสมาชิกสำเร็จ, ID: $newRiderId');
  }

  void register() async{
    await registerNewRider();
    Navigator.of(context).pop();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'สำเร็จ',
          style: TextStyle(
            fontSize: Get.textTheme.headlineMedium!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE53935),
            // letterSpacing: 1
          ),
        ),
        content: Text(
          'สมัครสมาชิกสำเร็จ',
          style: TextStyle(
            fontSize: Get.textTheme.titleLarge!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF7622),
            // letterSpacing: 1
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFFE53935)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
              )),
            ),
            child: Text(
              'ปิด',
              style: TextStyle(
                fontSize: Get.textTheme.titleLarge!.fontSize,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFFFFF),
                // letterSpacing: 1
              ),
            ),
          ),
        ],
      ),
    );
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
}
