import 'package:flutter/material.dart';

class MainUserPage extends StatefulWidget {
  const MainUserPage({super.key});

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {
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
          // Container ที่เป็นวงกลมสีเหลืองทับอยู่บนรูป
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
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    SizedBox(
                      width: 400, // กำหนดความกว้างของ TextField
                      child: TextField(
                        decoration: InputDecoration(
                          hintText:
                              'ค้นหาผู้ที่ต้องการจัดส่ง', // ข้อความที่อยู่ทางซ้ายสุด
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20), // ขอบมน
                          ),
                          suffixIcon:
                              Icon(Icons.search), // ไอคอนที่อยู่ทางขวาสุด
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                        width: 400, // กำหนดความกว้างของ Container
                        height: 150, // กำหนดความสูงของ Container
                        decoration: BoxDecoration(
                          color: Colors.white, // สีพื้นหลังของ Container
                          border: Border.all(
                              color: Colors.black, width: 1), // ขอบสีดำ
                          borderRadius: BorderRadius.circular(20), // โค้งขอบ
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/UserProfile.jpg',
                                width: 100, // กำหนดความกว้างของรูป
                                height: 100, // กำหนดความสูงของรูป
                                fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Username",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  Text("080-xxx-xxxx",
                                      style: TextStyle(color: Colors.blueGrey)),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(
                                            0xFF56DA40)), // กำหนดสีพื้นหลัง
                                  ),
                                  child: const Text("รับออร์เดอร์"),
                                ),
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
