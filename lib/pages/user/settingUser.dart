import 'package:delivery_application/pages/forgotPassword/ResetPassword.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingUserPage extends StatefulWidget {
  const SettingUserPage({super.key});

  @override
  State<SettingUserPage> createState() => _SettingUserPageState();
}

class _SettingUserPageState extends State<SettingUserPage> {
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
                child: Image.asset(
                  'assets/images/UserProfile.jpg',
                  width: Get.height / 6, // กำหนดความกว้างของรูป
                  height: Get.height / 6, // กำหนดความสูงของรูป
                  fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                ),
              ),
              SizedBox(height: Get.textTheme.headlineSmall!.fontSize),
              Text(
                "Username",
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: Get.textTheme.headlineSmall!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Get.textTheme.labelSmall!.fontSize),
              Text("080-XXX-XXXX",
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
                    Padding(
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
                          SizedBox(width: Get.textTheme.labelLarge!.fontSize!),
                          // ข้อความ
                          Expanded(
                            child: Text("ข้อมูลส่วนตัว",
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
                    GestureDetector(
                      onTap: () {
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
                            SizedBox(width: Get.textTheme.labelLarge!.fontSize!),
                            // ข้อความ
                            Expanded(
                              child: Text("เปลี่ยนรหัสผ่าน",
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
                                      Get.textTheme.displaySmall!.fontSize! * 3, Get.textTheme.titleLarge!.fontSize! * 2.5),
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
                                      Get.textTheme.displaySmall!.fontSize! * 3, Get.textTheme.titleLarge!.fontSize! * 2.5),
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
                    color: const Color(0xFFF6F8FA),  // สีพื้นหลังของ Container
                    //border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                    borderRadius: BorderRadius.circular(20), // โค้งขอบ
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(Get.textTheme.labelLarge!.fontSize!),
                    child: Row(
                      children: [
                        // วงกลมสีขาวพร้อมไอคอนด้านใน
                        Container(
                          width: Get.textTheme.labelLarge!.fontSize! * 3, // กำหนดความกว้างของวงกลม
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
                          child: Text(
                            "ออกจากระบบ",
                            style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: Get.textTheme.titleMedium!.fontSize,
                                  )
                          ),
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
