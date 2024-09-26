import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {

  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController numCarCtl = TextEditingController();
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: GestureDetector(
                  onTap: () {
                    log("change image");
                  },
                  child: Container(
                    width: 180, // กำหนดความกว้าง
                    height: 180,
                    child: Stack(
                      children: [
                        Container(
                          width: 180, // กำหนดความกว้าง
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFFA0A0), // สีของกรอบ
                              width: 10, // ความหนาของกรอบ
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              "",
                              width: 160, // กำหนดความกว้างของรูปภาพ
                              height: 160, // กำหนดความสูงของรูปภาพ
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 40, // กำหนดความกว้างของวงกลมเล็ก
                            height: 40, // กำหนดความสูงของวงกลมเล็ก
                            decoration: BoxDecoration(
                              color:
                                  Color(0xFFE53935), // สีพื้นหลังของวงกลมเล็ก
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFE53935), // สีของกรอบวงกลมเล็ก
                                width: 2.5, // ความหนาของกรอบวงกลมเล็ก
                              ),
                            ),
                            child: const Icon(
                              Icons.edit, // ไอคอนที่จะแสดงในวงกลมเล็ก
                              color: Colors.white, // สีของไอคอน
                              size: 30, // ขนาดของไอคอน
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
                    padding: EdgeInsets.symmetric(vertical: Get.textTheme.titleSmall!.fontSize!),
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
                        borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
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
                    padding: EdgeInsets.symmetric(vertical: Get.textTheme.titleSmall!.fontSize!),
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
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFEBEBEB),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
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
                    padding: EdgeInsets.symmetric(vertical: Get.textTheme.titleSmall!.fontSize!),
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
                        borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
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
                    padding: EdgeInsets.symmetric(vertical: Get.textTheme.titleSmall!.fontSize!),
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
                        borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: Get.textTheme.titleLarge!.fontSize!),
                    child: FilledButton(
                        onPressed: () => dialogRegister(),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(
                              btnSizeWidth * 5,
                              btnSizeHeight * 2)), // กำหนดขนาดของปุ่ม
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFE53935)), // สีพื้นหลังของปุ่ม
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                          )),
                        ),
                        child: Text('LOGIN',
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
    );
  }
  
  dialogRegister() {}
}