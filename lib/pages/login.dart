import 'dart:developer';

import 'package:delivery_application/pages/register/RiderRegister.dart';
import 'package:delivery_application/pages/register/UserRegister.dart';
import 'package:delivery_application/pages/rider/mainRider.dart';
import 'package:delivery_application/pages/user/mainUser.dart';
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
  var btnSizeWidth = (Get.textTheme.displaySmall!.fontSize)!;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        log('cant pop');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: Container(
                      width: 270, // กำหนดความกว้าง
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: const Color(0xFFFFFFFF), // สีของกรอบ
                          width: 5, // ความหนาของกรอบ
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text('Forgot password ?',
                            style: TextStyle(
                              fontSize: Get.textTheme.titleLarge!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF939393),
                              // letterSpacing: 1
                            ))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton(
                          onPressed: () => dialogRegister(),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                                btnSizeWidth * 5,
                                btnSizeHeight * 3)), // กำหนดขนาดของปุ่ม
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFFF7622)), // สีพื้นหลังของปุ่ม
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
                                // letterSpacing: 1
                              ))),
                      FilledButton(
                          onPressed: () => dialogLogin(),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                                btnSizeWidth * 5,
                                btnSizeHeight * 3)), // กำหนดขนาดของปุ่ม
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFE53935)), // สีพื้นหลังของปุ่ม
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12.0), // ทำให้ขอบมน
                            )),
                          ),
                          child: Text('LOGIN',
                              style: TextStyle(
                                fontSize: Get.textTheme.titleLarge!.fontSize,
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
        ),
      ),
    );
  }

  dialogRegister(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // ทำให้มุมโค้งมน
        ),
        title: Text(
          'เลือกประเภท',
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(btnSizeWidth * 3, btnSizeHeight * 2.5),
                    backgroundColor: const Color(0xFFFF7622),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'USER',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleLarge!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF),
                      // letterSpacing: 1
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.to(() => const UserRegisterPage());
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(btnSizeWidth * 3, btnSizeHeight * 2.5),
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'RIDER',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleLarge!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF),
                      // letterSpacing: 1
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.to(() => const RiderRegisterPage());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  dialogLogin() {
    var width = Get.width / 8;
    var height = Get.height / 8;
    log('$width x $height');
    if (phoneCtl.text.isEmpty || passwordCtl.text.isEmpty) {
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
              // letterSpacing: 1
            ),
          ),
          content: Text(
            'โปรดใส่หมายเลขโทรศัพท์หรือรหัสผ่าน',
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // ทำให้มุมโค้งมน
          ),
          title: Text(
            'เลือกประเภท',
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(btnSizeWidth * 3, btnSizeHeight * 2.5),
                      backgroundColor: const Color(0xFFFF7622),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'USER',
                      style: TextStyle(
                        fontSize: Get.textTheme.titleLarge!.fontSize,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFFFFF),
                        // letterSpacing: 1
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      loginUser();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(btnSizeWidth * 3, btnSizeHeight * 2.5),
                      backgroundColor: const Color(0xFFE53935),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'RIDER',
                      style: TextStyle(
                        fontSize: Get.textTheme.titleLarge!.fontSize,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFFFFF),
                        // letterSpacing: 1
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      loginRider();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
  
  void loginUser() {
    log('UserLogin');
    Get.to(() => const MainUserPage());
  }
  
  void loginRider() {
    log('RiderLogin');
    Get.to(() => const MainRiderPage());
  }
}
