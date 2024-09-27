import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/login.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController confirmPasswordCtl = TextEditingController();
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;
  ForgotPassword forgotUser = ForgotPassword();
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forgotUser = context.read<Appdata>().forgotUser;
    log(context.read<Appdata>().page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Text(
          'Reset password',
          style: TextStyle(
            fontSize: Get.textTheme.titleLarge!.fontSize,
            color: Colors.black,
            fontFamily: GoogleFonts.poppins().fontFamily,
            // letterSpacing: 1
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.textTheme.titleLarge!.fontSize!),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Get.textTheme.displaySmall!.fontSize!),
                child: Text(
                  'เปลี่ยนรหัสผ่าน',
                  style: TextStyle(
                    fontSize: Get.textTheme.displaySmall!.fontSize,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    // letterSpacing: 1
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
                    obscureText: true,
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
                    padding: EdgeInsets.symmetric(
                        vertical: Get.textTheme.labelSmall!.fontSize!),
                    child: Text(
                      'ยืนยันรหัสผ่าน',
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
                    controller: confirmPasswordCtl,
                    obscureText: true,
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
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Get.textTheme.displaySmall!.fontSize!),
                child: FilledButton(
                    onPressed: () => dialogReset(),
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
                    child: Text('เปลี่ยนรหัสผ่าน',
                        style: TextStyle(
                          fontSize: Get.textTheme.titleLarge!.fontSize,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dialogReset() {
    if (passwordCtl.text.isEmpty || confirmPasswordCtl.text.isEmpty) {
      showErrorDialog('คุณยังไม่ได้กรอกรหัสผ่าน');
    } else if (passwordCtl.text.trim().isEmpty ||
        confirmPasswordCtl.text.trim().isEmpty) {
      showErrorDialog('รหัสผ่านไม่ถูกต้อง');
    } else if (confirmPasswordCtl.text != passwordCtl.text) {
      showErrorDialog('รหัสผ่านไม่ตรงกัน');
    } else {
      resetPassword();
    }
  }

// ฟังก์ชันสำหรับ hash รหัสผ่าน
  String hashPassword(String password) {
    var bytes = utf8.encode(password); // แปลงรหัสผ่านเป็น byte
    var digest = sha256.convert(bytes); // ทำการ hash ด้วย SHA-256
    return digest.toString(); // คืนค่า hash ในรูปแบบ string
  }

  void resetPassword() async {
    if (forgotUser.type == 'user') {
      var data = {
        'id': forgotUser.id,
        'password': hashPassword(passwordCtl.text),
      };
      await db.collection('user').doc(forgotUser.id.toString()).update(data);
    } else if (forgotUser.type == 'rider'){
      var data = {
        'id': forgotUser.id,
        'password': hashPassword(passwordCtl.text),
      };
      await db.collection('rider').doc(forgotUser.id.toString()).update(data);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
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
          'เปลี่ยนรหัสผ่านสำเร็จ',
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
              if(context.read<Appdata>().page == "Forgot"){
                context.read<Appdata>().page = "";
                Get.to(() => const LoginPage());
              } else {
                Navigator.of(context).pop();
              }
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
