import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  var btnSizeHeight = (Get.textTheme.titleLarge!.fontSize)!;
  var btnSizeWidth = (Get.textTheme.titleLarge!.fontSize)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: Container(
                  width: 180, // กำหนดความกว้าง
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD9D9D9), // สีของกรอบ
                      width: 10, // ความหนาของกรอบ
                    ),
                  ),
                  child: Image.asset('assets/images/RiderLogo.jpg',
                      width: 160, // กำหนดความกว้างของรูปภาพ
                      height: 160, // กำหนดความสูงของรูปภาพ
                      fit: BoxFit.cover)), // ปรับขนาดรูปภาพให้เต็มพื้นที่
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
            TextButton(
                onPressed: () {},
                child: Text('Forgot Password?',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleLarge!.fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF939393),
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      // letterSpacing: 1
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                      onPressed: () => login(),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(
                            btnSizeWidth * 2.8,
                            btnSizeHeight * 2)), // กำหนดขนาดของปุ่ม
                        backgroundColor: MaterialStateProperty.all(
                            const Color(0xFFFF7622)), // สีพื้นหลังของปุ่ม
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // ทำให้ขอบมน
                        )),
                      ),
                      child: Text('SIGN UP',
                          style: TextStyle(
                            fontSize: Get.textTheme.titleMedium!.fontSize,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFFFFF),
                            // letterSpacing: 1
                          ))),
                  FilledButton(
                      onPressed: () => login(),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(
                            btnSizeWidth * 2.8,
                            btnSizeHeight * 2)), // กำหนดขนาดของปุ่ม
                        backgroundColor: MaterialStateProperty.all(
                            const Color(0xFFE53935)), // สีพื้นหลังของปุ่ม
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // ทำให้ขอบมน
                        )),
                      ),
                      child: Text('LOGIN',
                          style: TextStyle(
                            fontSize: Get.textTheme.titleMedium!.fontSize,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFFFFF),
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  login() {
    var width = Get.width;
    var height = Get.height;
    log('$width x $height');
    var fontSize = Get.textTheme.headlineSmall!.fontSize;
    log(fontSize.toString());
  }
}
