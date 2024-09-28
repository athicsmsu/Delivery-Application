import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/register/SelectMap.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({super.key});

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController addressCtl = TextEditingController();
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;
  var imageSize = Get.height / 6;
  XFile? image;
  String? imageUrl;
  UserProfile userProfile = UserProfile();
  var db = FirebaseFirestore.instance;
  late StreamSubscription listener;
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProfile = context.read<Appdata>().user;
    final docRef = db.collection("user").doc(userProfile.id.toString());
    listener = docRef.snapshots().listen(
      (event) {
        data = event.data();
        log(event.data().toString());
        nameCtl.text = data['name'];
        phoneCtl.text = data['phone'];
        addressCtl.text = data['address'];
        imageUrl = data['image'];
        if (data['latLng'] != null && data['latLng'] is Map) {
          latLng = LatLng(data['latLng']['latitude'] ?? 0.0,
              data['latLng']['longitude'] ?? 0.0);
        }
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
                    child: Container(
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
                                          "assets/images/UserProfile.jpg",
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
                        padding: EdgeInsets.only(
                            bottom: Get.textTheme.titleSmall!.fontSize!,
                            top: Get.height / 15),
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
      ),
    );
  }

  map() {
    Get.to(() => const SelectMapPage());
  }

  void edit() async {
    var pathImage;
    if (image != null) {
      pathImage = await uploadImage(image!); // ใช้ await เพื่อรอ URL ของภาพ
      if (imageUrl != null) {
        log(imageUrl!);
        await deleteImage(imageUrl!);
      }
    } else {
      log(imageUrl!);
      pathImage = imageUrl; // ใช้ภาพที่มีอยู่แล้วถ้าไม่ได้เปลี่ยน
    }
    var data = {
      'name': nameCtl.text,
      'phone': phoneCtl.text,
      'address': addressCtl.text,
      'latLng': {'latitude': latLng.latitude, 'longitude': latLng.longitude},
      'image': pathImage
      // 'createAt': DateTime.timestamp()
    };
    await db
        .collection('user')
        .doc(userProfile.id.toString())
        .update(data); // ใช้ ID เป็น document ID
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
    latLng = context.read<Appdata>().latLng;
    // ตรวจสอบว่ามีช่องว่างหรือไม่
    if (nameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        addressCtl.text.isEmpty) {
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
    // ตรวจสอบที่อยู่
    else if (addressCtl.text.trim().isEmpty) {
      showErrorDialog('ที่อยู่ของคุณไม่ถูกต้อง');
    } else {
      dialogLoad(context);
      QuerySnapshot querySnapshot = await db
          .collection('user')
          .where('phone', isEqualTo: phoneCtl.text)
          .get();

      if (querySnapshot.docs.isNotEmpty && phoneCtl.text != data['phone']) {
        // ถ้าพบหมายเลขโทรศัพท์ซ้ำ
        Navigator.of(context).pop();
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

  void dialogLoad(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ปิดการทำงานของการกดนอก dialog เพื่อปิด
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent, // พื้นหลังโปร่งใส
          child: Center(
            child:
                CircularProgressIndicator(), // แสดงแค่ CircularProgressIndicator
          ),
        );
      },
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

 Future<void> deleteImage(String imageUrl) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    // ดึงชื่อไฟล์จาก imageUrl (ส่วนท้ายของ URL หลังจาก 'images%2F')
    try {
      Uri uri = Uri.parse(imageUrl); // แปลง URL เป็น Uri
      String filePath = uri.pathSegments.last; // ดึงชื่อไฟล์จาก URL

      // แปลงชื่อไฟล์ที่มีการเข้ารหัส (เช่น %2F) กลับเป็นตัวอักษรปกติ
      String decodedFileName = Uri.decodeComponent(filePath);

      // สร้าง Reference ด้วยชื่อไฟล์ที่ถูกต้อง
      Reference ref = storage.ref().child("images/$decodedFileName");

      // ลบไฟล์จาก Firebase Storage
      await ref.delete();
      log("Image deleted successfully");
    } catch (e) {
      log("Error deleting image: $e");
    }
  }


  // @override
  // void dispose() {
  //   listener.cancel(); // ยกเลิกการฟัง Stream ก่อน widget จะถูกลบ
  //   super.dispose();
  // }
}
