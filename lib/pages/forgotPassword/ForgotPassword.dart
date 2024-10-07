import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_application/pages/forgotPassword/ResetPassword.dart';
import 'package:delivery_application/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController phoneCtl = TextEditingController();
  var btnSizeHeight = (Get.textTheme.displaySmall!.fontSize)!;
  var btnSizeWidth = Get.width;
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Text(
          'Forgot password',
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
                  'ลืมรหัสผ่าน',
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                          10), // จำกัดตัวเลขที่ป้อนได้สูงสุด 10 ตัว
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Get.textTheme.displaySmall!.fontSize!),
                child: FilledButton(
                    onPressed: () => dialogForgot(),
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size(
                          btnSizeWidth * 5,
                          btnSizeHeight * 2)), // กำหนดขนาดของปุ่ม
                      backgroundColor: WidgetStateProperty.all(
                          const Color(0xFFE53935)), // สีพื้นหลังของปุ่ม
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                      )),
                    ),
                    child: Text('ลืมรหัสผ่าน',
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

  dialogForgot() {
    if (phoneCtl.text.length < 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phoneCtl.text)) {
      showErrorDialog('ผิดพลาด', 'หมายเลขโทรศัพท์ของคุณไม่ถูกต้อง', context);
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
                      minimumSize: Size(
                          Get.textTheme.displaySmall!.fontSize! * 3,
                          Get.textTheme.titleLarge!.fontSize! * 2.5),
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
                      forgotPasswordUser();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(
                          Get.textTheme.displaySmall!.fontSize! * 3,
                          Get.textTheme.titleLarge!.fontSize! * 2.5),
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
                      forgotPasswordRider();
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

  void forgotPasswordUser() async {
    var inboxRef = db.collection("user");
    var query = inboxRef.where("phone", isEqualTo: phoneCtl.text);
    var result = await query.get();
    if (result.docs.isNotEmpty) {
      ForgotPassword user = ForgotPassword();
      user.id = result.docs.first['id'];
      user.type = "user";
      context.read<Appdata>().forgotUser = user;
      context.read<Appdata>().page = "Forgot";
      Get.to(() => const ResetPasswordPage());
    } else {
      showErrorDialog(
          'ไม่พบผู้ใช้', 'หมายเลขโทรศัพท์นี้ยังไม่ได้ลงทะเบียน', context);
    }
  }

  void forgotPasswordRider() async {
    var inboxRef = db.collection("rider");
    var query = inboxRef.where("phone", isEqualTo: phoneCtl.text);
    var result = await query.get();
    if (result.docs.isNotEmpty) {
      ForgotPassword rider = ForgotPassword();
      rider.id = result.docs.first['id'];
      rider.type = "rider";
      context.read<Appdata>().forgotUser = rider;
      context.read<Appdata>().page = "Forgot";
      Get.to(() => const ResetPasswordPage());
    } else {
      showErrorDialog(
          'ไม่พบผู้ใช้', 'หมายเลขโทรศัพท์นี้ยังไม่ได้ลงทะเบียน', context);
    }
  }
}