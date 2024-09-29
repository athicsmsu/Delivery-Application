import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckStatusOrderUserPage extends StatefulWidget {
  const CheckStatusOrderUserPage({super.key});

  @override
  State<CheckStatusOrderUserPage> createState() => _CheckStatusOrderUserPageState();
}

class _CheckStatusOrderUserPageState extends State<CheckStatusOrderUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFFF),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.lightBlueAccent,
            width: Get.width / 1.1,
            height: Get.height / 3,
            child: const Center(child: Text("Map")),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Get.textTheme.titleLarge!.fontSize!),
            child: Container(
                width: Get.width / 1.2, // กำหนดความกว้างของ Container
                height: Get.height / 10, // กำหนดความสูงของ Container
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลังของ Container
                  border: Border.all(
                      color: const Color.fromARGB(127, 153, 153, 153),
                      width: 1), // ขอบสีดำ
                  borderRadius: BorderRadius.circular(12), // โค้งขอบ
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/RegisterDemo.jpg',
                        width: Get.height / 12, // กำหนดความกว้างของรูป
                        height: Get.height / 12, // กำหนดความสูงของรูป
                        fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Get.textTheme.bodySmall!.fontSize!),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Username",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: Get.textTheme.bodySmall!.fontSize!),
                          Text("080-xxx-xxxx",
                              style: TextStyle(
                                fontSize: Get.textTheme.titleMedium!.fontSize,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF747783),
                              )),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: Get.textTheme.titleMedium!.fontSize! * 6,
                          height: Get.textTheme.titleMedium!.fontSize! * 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(8), // โค้งขอบ
                          ),
                          child: Text(
                            "กย 1515",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                 padding: EdgeInsets.only(
                  top: Get.textTheme.titleSmall!.fontSize! * 1.5,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle, // ไอคอนเครื่องหมายถูก
                      size: Get.textTheme.titleSmall!.fontSize! *
                          2.5, // ขนาดของไอคอน
                      color: const Color(0xFFFF7622), // สีของไอคอน
                    ),
                    Container(
                      width: 5, // ความกว้างของเส้น
                      height: Get.textTheme.titleSmall!.fontSize! *
                          3, // ความสูงของเส้น
                      color: const Color(0xFFFF7622), // สีของเส้น
                    ),
                    Icon(
                      Icons.check_circle, // ไอคอนเครื่องหมายถูกอีกครั้ง
                      size: Get.textTheme.titleSmall!.fontSize! *
                          2.5, // ขนาดของไอคอน
                      color: const Color(0xFFBFBCBA), // สีของไอคอน
                    ),
                    Container(
                      width: 5, // ความกว้างของเส้น
                      height: Get.textTheme.titleSmall!.fontSize! *
                          3, // ความสูงของเส้น
                      color: const Color(0xFFBFBCBA), // สีของเส้น
                    ),
                    Icon(
                      Icons.check_circle, // ไอคอนเครื่องหมายถูกอีกครั้ง
                      size: Get.textTheme.titleSmall!.fontSize! *
                          2.5, // ขนาดของไอคอน
                      color: const Color(0xFFBFBCBA), // สีของไอคอน
                    ),
                    Container(
                      width: 5, // ความกว้างของเส้น
                      height: Get.textTheme.titleSmall!.fontSize! *
                          3, // ความสูงของเส้น
                      color: const Color(0xFFBFBCBA), // สีของเส้น
                    ),
                    Icon(
                      Icons.check_circle, // ไอคอนเครื่องหมายถูกอีกครั้ง
                      size: Get.textTheme.titleSmall!.fontSize! *
                          2.5, // ขนาดของไอคอน
                      color: const Color(0xFFBFBCBA), // สีของไอคอน
                    ),
                  ],
                ),
              ),
              Padding(
                padding:EdgeInsets.only(top:  Get.textTheme.titleSmall!.fontSize! * 1.5,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "รอไรเดอร์มารับสินค้า",
                      style: TextStyle(
                        fontSize: Get.textTheme.titleSmall!.fontSize,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: const Color(0xFFFF7622),
                      ),
                    ),
                    SizedBox(
                      height: Get.textTheme.titleSmall!.fontSize! * 4,
                    ),
                    Text(
                      "ไรเดอร์รับงาน",
                      style: TextStyle(
                        fontSize: Get.textTheme.titleSmall!.fontSize,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    SizedBox(
                      height: Get.textTheme.titleSmall!.fontSize! * 4,
                    ),
                    Text(
                      "ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง",
                      style: TextStyle(
                        fontSize: Get.textTheme.titleSmall!.fontSize,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    SizedBox(
                      height: Get.textTheme.titleSmall!.fontSize! * 4,
                    ),
                    Text(
                      "ไรเดอร์นำส่งสินค้าแล้ว",
                      style: TextStyle(
                        fontSize: Get.textTheme.titleSmall!.fontSize,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
