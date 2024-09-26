import 'package:flutter/material.dart';

class SettingRiderPage extends StatefulWidget {
  const SettingRiderPage({super.key});

  @override
  State<SettingRiderPage> createState() => _SettingRiderPageState();
}

class _SettingRiderPageState extends State<SettingRiderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ClipOval(
                                child: Image.asset(
                                  'assets/images/RiderHome.jpg',
                                  width: 150, // กำหนดความกว้างของรูป
                                  height: 150, // กำหนดความสูงของรูป
                                  fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                                ),
            ),
            SizedBox(height: 20),
            Text("Username"),
            SizedBox(height: 5),
            Text("080-XXX-XXXX"),
            SizedBox(height: 20),
            Container(
              width: 350,
              height: 170,
              decoration: BoxDecoration(
                color:
                    Color.fromARGB(255, 230, 230, 230), // สีพื้นหลังของ Container
                //border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                borderRadius: BorderRadius.circular(20), // โค้งขอบ
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        // วงกลมสีขาวพร้อมไอคอนด้านใน
                        Container(
                          width: 50, // กำหนดความกว้างของวงกลม
                          height: 50, // กำหนดความสูงของวงกลม
                          decoration: BoxDecoration(
                            color: Colors.white, // สีของวงกลม
                            shape: BoxShape.circle, // กำหนดให้เป็นรูปวงกลม
                          ),
                          child: Icon(Icons.person_outline),
                        ),
                    
                        SizedBox(width: 16),
                    
                        // ข้อความ
                        Expanded(
                          child: Text(
                            "ข้อมูลส่วนตัว",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                    
                        // ไอคอนลูกศร
                        Icon(Icons.keyboard_arrow_right_outlined),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        // วงกลมสีขาวพร้อมไอคอนด้านใน
                        Container(
                          width: 50, // กำหนดความกว้างของวงกลม
                          height: 50, // กำหนดความสูงของวงกลม
                          decoration: BoxDecoration(
                            color: Colors.white, // สีของวงกลม
                            shape: BoxShape.circle, // กำหนดให้เป็นรูปวงกลม
                          ),
                          child: Icon(Icons.settings),
                        ),
                    
                        SizedBox(width: 16),
                    
                        // ข้อความ
                        Expanded(
                          child: Text(
                            "เปลี่ยนรหัสผ่าน",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                    
                        // ไอคอนลูกศร
                        Icon(Icons.keyboard_arrow_right_outlined),
                      ],
                    ),
                  ),
                ],
              ),
              
            ),
            SizedBox(height: 20),
            Container(
              width: 350,
              height: 80,
              decoration: BoxDecoration(
                color:
                    Color.fromARGB(255, 230, 230, 230), // สีพื้นหลังของ Container
                //border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                borderRadius: BorderRadius.circular(20), // โค้งขอบ
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                        children: [
                          // วงกลมสีขาวพร้อมไอคอนด้านใน
                          Container(
                            width: 50, // กำหนดความกว้างของวงกลม
                            height: 50, // กำหนดความสูงของวงกลม
                            decoration: BoxDecoration(
                              color: Colors.white, // สีของวงกลม
                              shape: BoxShape.circle, // กำหนดให้เป็นรูปวงกลม
                            ),
                            child: Icon(Icons.logout),
                          ),
                      
                          SizedBox(width: 16),
                      
                          // ข้อความ
                          Expanded(
                            child: Text(
                              "ออกจากระบบ",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                      
                          // ไอคอนลูกศร
                          Icon(Icons.keyboard_arrow_right_outlined),
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
