import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/forgotPassword/ResetPassword.dart';
import 'package:delivery_application/pages/user/profileUser.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SettingUserPage extends StatefulWidget {
  const SettingUserPage({super.key});

  @override
  State<SettingUserPage> createState() => _SettingUserPageState();
}

class _SettingUserPageState extends State<SettingUserPage> {
  var db = FirebaseFirestore.instance;
  late StreamSubscription listener;
  UserProfile userProfile = UserProfile();
  XFile? image;
  String? imageUrl;
  var data;

  @override
  void initState() {
    super.initState();
    userProfile = context.read<Appdata>().user;
    final docRef = db.collection("user").doc(userProfile.id.toString());
    listener = docRef.snapshots().listen(
      (event) {
        data = event.data();
        log("current data: ${event.data()}");
        // ตรวจสอบว่ามีข้อมูลและฟิลด์ image หรือไม่
        if (data != null &&
            data.containsKey('image') &&
            data['image'] != null) {
          imageUrl = data['image']; // Assuming it's a URL or path
        } else {
          imageUrl = null; // ป้องกัน error ถ้าไม่มี image
        }
        setState(() {}); // Update the UI when data is loaded
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Padding(
        padding: EdgeInsets.only(top: Get.height / 7),
        child: Center(
          child: Column(
            children: [
              ClipOval(
                child: (imageUrl != null)
                    ? Image.file(
                        File(imageUrl!),
                        width: Get.height / 6, // กำหนดความกว้างของรูป
                        height: Get.height / 6, // กำหนดความสูงของรูป
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        'assets/images/UserProfile.jpg',
                        width: Get.height / 6, // กำหนดความกว้างของรูป
                        height: Get.height / 6, // กำหนดความสูงของรูป
                        fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                      ),
              ),
              SizedBox(height: Get.textTheme.headlineSmall!.fontSize),
              Text(
                data!['name'],
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: Get.textTheme.headlineSmall!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Get.textTheme.labelSmall!.fontSize),
              Text(data!['phone'],
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: Get.textTheme.titleMedium!.fontSize,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: Get.textTheme.headlineSmall!.fontSize),
              Container(
                width: Get.width / 1.2,
                height: Get.height / 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FA), // สีพื้นหลังของ Container
                  //border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                  borderRadius: BorderRadius.circular(20), // โค้งขอบ
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ProfileUserPage());
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.all(Get.textTheme.labelLarge!.fontSize!),
                        child: Row(
                          children: [
                            // วงกลมสีขาวพร้อมไอคอนด้านใน
                            Container(
                              width: Get.textTheme.labelLarge!.fontSize! *
                                  3, // กำหนดความกว้างของวงกลม
                              height: Get.textTheme.labelLarge!.fontSize! *
                                  3, // กำหนดความสูงของวงกลม
                              decoration: const BoxDecoration(
                                color: Colors.white, // สีของวงกลม
                                shape: BoxShape.circle, // กำหนดให้เป็นรูปวงกลม
                              ),
                              child: const Icon(Icons.person_outline),
                            ),
                            SizedBox(
                                width: Get.textTheme.labelLarge!.fontSize!),
                            // ข้อความ
                            Expanded(
                              child: Text("ข้อมูลส่วนตัว",
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize:
                                        Get.textTheme.titleMedium!.fontSize,
                                  )),
                            ),
                            // ไอคอนลูกศร
                            const Icon(Icons.keyboard_arrow_right_outlined),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        ForgotPassword user = ForgotPassword();
                        user.id = userProfile.id;
                        user.phone = data!['phone'];
                        user.type = "user";
                        context.read<Appdata>().forgotUser = user;
                        context.read<Appdata>().page = "";
                        Get.to(() => const ResetPasswordPage());
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.all(Get.textTheme.labelLarge!.fontSize!),
                        child: Row(
                          children: [
                            // วงกลมสีขาวพร้อมไอคอนด้านใน
                            Container(
                              width: Get.textTheme.labelLarge!.fontSize! *
                                  3, // กำหนดความกว้างของวงกลม
                              height: Get.textTheme.labelLarge!.fontSize! *
                                  3, // กำหนดความสูงของวงกลม
                              decoration: const BoxDecoration(
                                color: Colors.white, // สีของวงกลม
                                shape: BoxShape.circle, // กำหนดให้เป็นรูปวงกลม
                              ),
                              child: const Icon(Icons.settings),
                            ),
                            SizedBox(
                                width: Get.textTheme.labelLarge!.fontSize!),
                            // ข้อความ
                            Expanded(
                              child: Text("เปลี่ยนรหัสผ่าน",
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize:
                                        Get.textTheme.titleMedium!.fontSize,
                                  )),
                            ),

                            // ไอคอนลูกศร
                            const Icon(Icons.keyboard_arrow_right_outlined),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.textTheme.labelLarge!.fontSize!),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16.0), // ทำให้มุมโค้งมน
                      ),
                      title: Text(
                        'ออกจากระบบ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Get.textTheme.headlineMedium!.fontSize,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE53935),
                          // letterSpacing: 1
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: Get.textTheme.titleLarge!.fontSize!),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(
                                      Get.textTheme.displaySmall!.fontSize! * 3,
                                      Get.textTheme.titleLarge!.fontSize! *
                                          2.5),
                                  backgroundColor: const Color(0xFFFF7622),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  'ยกเลิก',
                                  style: TextStyle(
                                    fontSize:
                                        Get.textTheme.titleLarge!.fontSize,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFFFFFF),
                                    // letterSpacing: 1
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(
                                      Get.textTheme.displaySmall!.fontSize! * 3,
                                      Get.textTheme.titleLarge!.fontSize! *
                                          2.5),
                                  backgroundColor: const Color(0xFFE53935),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  'ยืนยัน',
                                  style: TextStyle(
                                    fontSize:
                                        Get.textTheme.titleLarge!.fontSize,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFFFFFF),
                                    // letterSpacing: 1
                                  ),
                                ),
                                onPressed: () {
                                  try {
                                    listener.cancel().then(
                                      (value) {
                                        log('Listener is stopped');
                                      },
                                    );
                                  } catch (e) {
                                    log('Listener is not running...');
                                  }
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: Get.width / 1.2,
                  height: Get.height / 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8FA), // สีพื้นหลังของ Container
                    //border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                    borderRadius: BorderRadius.circular(20), // โค้งขอบ
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.all(Get.textTheme.labelLarge!.fontSize!),
                    child: Row(
                      children: [
                        // วงกลมสีขาวพร้อมไอคอนด้านใน
                        Container(
                          width: Get.textTheme.labelLarge!.fontSize! *
                              3, // กำหนดความกว้างของวงกลม
                          height: Get.textTheme.labelLarge!.fontSize! *
                              3, // กำหนดความสูงของวงกลม
                          decoration: const BoxDecoration(
                            color: Colors.white, // สีของวงกลม
                            shape: BoxShape.circle, // กำหนดให้เป็นรูปวงกลม
                          ),
                          child: const Icon(Icons.logout),
                        ),
                        SizedBox(width: Get.textTheme.labelLarge!.fontSize!),
                        // ข้อความ
                        Expanded(
                          child: Text("ออกจากระบบ",
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: Get.textTheme.titleMedium!.fontSize,
                              )),
                        ),

                        // ไอคอนลูกศร
                        const Icon(Icons.keyboard_arrow_right_outlined),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
