import 'package:delivery_application/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    if (passwordCtl.text.isEmpty ||
        confirmPasswordCtl.text.isEmpty) {
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
            'คุณยังไม่ได้กรอกรหัสผ่าน',
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
    } else if (passwordCtl.text.trim().isEmpty ||
        confirmPasswordCtl.text.trim().isEmpty) {
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
            'รหัสผ่านไม่ถูกต้อง',
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
    } else if (confirmPasswordCtl.text != passwordCtl.text) {
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
            'รหัสผ่านไม่ตรงกัน',
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
      resetPassword();
    }
  }

  void resetPassword() {
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
              Get.to(() => const LoginPage());
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
}
