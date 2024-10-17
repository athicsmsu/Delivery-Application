import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/forgotPassword/ResetPassword.dart';
import 'package:delivery_application/pages/rider/profileRider.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SettingRiderPage extends StatefulWidget {
  const SettingRiderPage({super.key});

  @override
  State<SettingRiderPage> createState() => _SettingRiderPageState();
}

class _SettingRiderPageState extends State<SettingRiderPage> {
  var db = FirebaseFirestore.instance;
  UserProfile userProfile = UserProfile();
  XFile? image;
  String? imageUrl;
  var data;

  @override
  void initState() {
    super.initState();
    userProfile = context.read<Appdata>().user;
    final docRef = db.collection("rider").doc(userProfile.id.toString());
    if (context.read<Appdata>().listener != null) {
      context.read<Appdata>().listener!.cancel();
      context.read<Appdata>().listener = null;
    }
    context.read<Appdata>().listener = docRef.snapshots().listen(
      (event) {
        data = event.data();
        imageUrl = data['image'];
        setState(() {}); // Update the UI when data is loaded
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (context.read<Appdata>().listener != null) {
          context.read<Appdata>().listener!.cancel();
          context.read<Appdata>().listener = null;
          log('stop listener in settingPageRider');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Padding(
          padding: EdgeInsets.only(top: Get.height / 7),
          child: Center(
            child: Column(
              children: [
                ClipOval(
                  child: (imageUrl != null)
                      ? Image.network(
                          imageUrl!,
                          width: Get.height / 6, // กำหนดความกว้างของรูป
                          height: Get.height / 6, // กำหนดความสูงของรูป
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // ถ้าเกิดข้อผิดพลาดในการโหลดรูปจาก URL
                            return Image.asset(
                              context.read<Appdata>().imageNetworkError,
                              width: Get.height / 6,
                              height: Get.height / 6,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          context.read<Appdata>().imageDefaltRider,
                          width: Get.height / 6, // กำหนดความกว้างของรูป
                          height: Get.height / 6, // กำหนดความสูงของรูป
                          fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                        ),
                ),
                SizedBox(height: Get.textTheme.headlineSmall!.fontSize),
                Text(
                  data != null && data.containsKey('name')
                      ? data['name']
                      : 'User Name',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: Get.textTheme.headlineSmall!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.textTheme.labelSmall!.fontSize),
                Text(
                  data != null && data.containsKey('phone')
                      ? data['phone']
                      : '000-000-0000',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: Get.textTheme.titleMedium!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.textTheme.labelSmall!.fontSize),
                Container(
                  width: Get.width / 1.2,
                  height: Get.height / 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8FA), // สีพื้นหลังของ Container
                    //border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                    borderRadius: BorderRadius.circular(20), // โค้งขอบ
                  ),
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ProfileRiderPage());
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
                                          fontWeight: FontWeight.bold,
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
                          ForgotPassword rider = ForgotPassword();
                          rider.id = userProfile.id;
                          rider.type = "rider";
                          context.read<Appdata>().forgotUser = rider;
                          context.read<Appdata>().page = "Profile";
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
                                          fontWeight: FontWeight.bold,
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
                    showLogoutDialog(context);
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
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
