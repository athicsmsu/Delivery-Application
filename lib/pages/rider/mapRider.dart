import 'dart:developer';

import 'package:delivery_application/pages/rider/menuRider.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class mapRiderPage extends StatefulWidget {
  const mapRiderPage({super.key});

  @override
  State<mapRiderPage> createState() => _mapRiderPageState();
}

class _mapRiderPageState extends State<mapRiderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [

            Container(
              color: Colors.lightBlueAccent,
              width: 350,
              height: 300,
              child: Center(child: Text("Map")),
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ถ่ายรูปสินค้าที่ได้รับ"),
                SizedBox(height: 16.0),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  color: Colors.black,
                  strokeWidth: 2,
                  dashPattern: [6, 3], // ความยาวของเส้นและช่องว่าง
                  child: Container(
                    width: 350,
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined, // เปลี่ยนเป็นไอคอนที่ต้องการ
                          size: 24.0, // ขนาดของไอคอน
                          color: Colors.black, // สีของไอคอน
                        ),
                        SizedBox(width: 8.0), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "เพิ่มรูปภาพ (จำเป็น)", // ข้อความที่ต้องการแสดง
                          style: TextStyle(
                            fontSize: 16.0, // ขนาดฟอนต์
                            color: Colors.black, // สีข้อความ
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF56DA40)),
                      minimumSize: MaterialStateProperty.all(Size(350, 60)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                      )),
                    ),
                    child: Text("ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง")),
              ],
            ),
                SizedBox(height: 25.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ถ่ายรูปสินค้าที่จัดส่งแล้ว"),
                SizedBox(height: 16.0),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  color: Colors.black,
                  strokeWidth: 2,
                  dashPattern: [6, 3], // ความยาวของเส้นและช่องว่าง
                  child: Container(
                    width: 350,
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined, // เปลี่ยนเป็นไอคอนที่ต้องการ
                          size: 24.0, // ขนาดของไอคอน
                          color: Colors.black, // สีของไอคอน
                        ),
                        SizedBox(width: 8.0), // ระยะห่างระหว่างไอคอนและข้อความ
                        Text(
                          "เพิ่มรูปภาพ (จำเป็น)", // ข้อความที่ต้องการแสดง
                          style: TextStyle(
                            fontSize: 16.0, // ขนาดฟอนต์
                            color: Colors.black, // สีข้อความ
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF56DA40)),
                      minimumSize: MaterialStateProperty.all(Size(350, 60)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                      )),
                    ),
                    child: Text("ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง")),
              ],
            ),
                SizedBox(height: 16.0),
            FilledButton(
                onPressed: () {
                  log("เสร็จสิ้น");
                   Get.to(() => const menuRiderPage());
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFFF7622)),
                  minimumSize: MaterialStateProperty.all(Size(400, 50)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                  )),
                ),
                child: Text("เสร็จสิ้น",
                style: TextStyle(
                      fontSize: Get.textTheme.titleSmall!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF),
                    )))
          ],
        ),
      ),
    );
  }
}
