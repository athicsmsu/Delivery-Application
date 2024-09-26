import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class detailUserPage extends StatefulWidget {
  const detailUserPage({super.key});

  @override
  State<detailUserPage> createState() => _detailUserPageState();
}

class _detailUserPageState extends State<detailUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter, // ตัดภาพจากด้านล่าง
              heightFactor:
                  0.65, // ปรับสัดส่วนที่ต้องการแสดง (0.65 แสดงครึ่งล่าง)
              child: Image.asset(
                'assets/images/UserBg.jpg',
                width: double.infinity,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity, // ความกว้างของ Container
              height: 600, // ความสูงของ Container
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5), // สีของ Container
                borderRadius:
                    BorderRadius.vertical(top: Radius.elliptical(200, 50)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                              Icons
                                  .camera_alt_outlined, // เปลี่ยนเป็นไอคอนที่ต้องการ
                              size: 24.0, // ขนาดของไอคอน
                              color: Colors.black, // สีของไอคอน
                            ),
                            SizedBox(
                                width: 8.0), // ระยะห่างระหว่างไอคอนและข้อความ
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("รายละเอียดสินค้า"),
                        Container(
                          width: 350,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white, // สีพื้นหลังของ Container
                            border: Border.all(
                                color: Colors.black, width: 2), // ขอบสีดำ
                            borderRadius: BorderRadius.circular(20), // โค้งขอบ
                          ),
                          child: Text(""),
                        ),
                      ],
                    ),
                    FilledButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFE53935)),
                          minimumSize: MaterialStateProperty.all(Size(400, 50)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // ทำให้ขอบมน
                          )),
                        ),
                        child: Text("ถัดไป"))
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 100, // ระยะจากด้านบน (ปรับตามความต้องการ)
            left: 100,
            child: Container(
              width: 250,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของ Container
                border: Border.all(color: Colors.black, width: 1), // ขอบสีดำ
                borderRadius: BorderRadius.circular(20), // โค้งขอบ
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_sharp),
                      SizedBox(width: 20),
                      Text("ที่อยู่ของคุณ"),
                    ],
                  ),
                  Divider(
                    color: Colors.grey, // สีของเส้น
                    thickness: 2, // ความหนาของเส้น
                    indent: 30, // ระยะห่างจากด้านซ้าย
                    endIndent: 30, // ระยะห่างจากด้านขวา
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 20),
                      Text("ที่อยู่ของคุณ"),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
