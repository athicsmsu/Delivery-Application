import 'dart:async';
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
import 'package:provider/provider.dart';

class ProfileRiderPage extends StatefulWidget {
  const ProfileRiderPage({super.key});

  @override
  State<ProfileRiderPage> createState() => _ProfileRiderPageState();
}

class _ProfileRiderPageState extends State<ProfileRiderPage> {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController numCarCtl = TextEditingController();
  UserProfile userProfile = UserProfile();
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;
  var imageSize = Get.height / 6;
  XFile? image;
  String? imageUrl;
  var db = FirebaseFirestore.instance;
  late StreamSubscription listener;
  var data;

  @override
  void initState() {
        // TODO: implement initState
    super.initState();
    userProfile = context.read<Appdata>().user;
    final docRef = db.collection("rider").doc(userProfile.id.toString());
    listener = docRef.snapshots().listen(
      (event) {
        data = event.data();
        nameCtl.text = data['name'];
        phoneCtl.text = data['phone'];
        numCarCtl.text = data['numCar'];
        imageUrl = data['image'];
        log("current data: ${event.data()}");
        setState(() {});
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Text(
          'Profile',
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
                                  : (imageUrl != null)
                                      ? Image.network(
                                          imageUrl!,
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
                      padding: EdgeInsets.only(
                          top: Get.textTheme.titleMedium!.fontSize!,
                          bottom: Get.textTheme.titleMedium!.fontSize!,
                          left: Get.textTheme.titleMedium!.fontSize!,
                          right: Get.textTheme.titleMedium!.fontSize!),
                      child: FilledButton(
                          onPressed: () => dialogEdit(),
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
                          child: Text('บันทึก',
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

  Future<String> uploadImage(XFile image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images/${image.name}");
    UploadTask uploadTask = ref.putFile(File(image.path));

    // รอให้การอัปโหลดเสร็จสิ้นแล้วดึง URL มา
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
    void edit() async {
    var pathImage;
    if (image != null) {
      pathImage = await uploadImage(image!); // ใช้ await เพื่อรอ URL ของภาพ
    } else {
      pathImage = imageUrl; // ใช้ภาพที่มีอยู่แล้วถ้าไม่ได้เปลี่ยน
    }
    var data = {
      'name': nameCtl.text,
      'phone': phoneCtl.text,
      'numCar': numCarCtl.text,
      'image': pathImage
      // 'createAt': DateTime.timestamp()
    };

    await db
        .collection('rider')
        .doc(userProfile.id.toString())
        .update(data); // ใช้ ID เป็น document ID

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
          'บันทึกข้อมูลสำเร็จ',
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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

    dialogEdit() async {
    // ตรวจสอบว่ามีช่องว่างหรือไม่
    if (nameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty || 
        numCarCtl.text.isEmpty) {
      showErrorDialog('คุณกรอกข้อมูลไม่ครบ');
    }
    // ตรวจสอบรูปแบบหมายเลขโทรศัพท์
    else if (phoneCtl.text.length < 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phoneCtl.text)) {
      showErrorDialog('หมายเลขโทรศัพท์ของคุณไม่ถูกต้อง');
    }
    // ตรวจสอบชื่อผู้ใช้
    else if (nameCtl.text.trim().isEmpty) {
      showErrorDialog('ชื่อผู้ใช้ของคุณไม่ถูกต้อง');
    }
    else {
      QuerySnapshot querySnapshot = await db
          .collection('rider')
          .where('phone', isEqualTo: phoneCtl.text)
          .get();

      if (querySnapshot.docs.isNotEmpty && phoneCtl.text != data['phone']) {
        // ถ้าพบหมายเลขโทรศัพท์ซ้ำ
        showErrorDialog('หมายเลขโทรศัพท์นี้ถูกใช้ไปแล้ว');
      } else {
        // ถ้าไม่มีหมายเลขโทรศัพท์ซ้ำ ให้ดำเนินการต่อไป
        edit(); // ฟังก์ชันสมัครสมาชิกใหม่
      }
    }
  }


  // ฟังก์ชันสำหรับแสดง Dialog ข้อความผิดพลาด
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ผิดพลาด',
          style: TextStyle(
            fontSize: Get.textTheme.headlineMedium!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE53935),
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: Get.textTheme.titleLarge!.fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF7622),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFFE53935)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              )),
            ),
            child: Text(
              'ปิด',
              style: TextStyle(
                fontSize: Get.textTheme.titleLarge!.fontSize,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}