import 'package:flutter/material.dart';

class mapUserPage extends StatefulWidget {
  const mapUserPage({super.key});

  @override
  State<mapUserPage> createState() => _mapUserPageState();
}

class _mapUserPageState extends State<mapUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            color: Colors.lightBlueAccent,
            width: 350,
            height: 300,
            child: Center(child: Text("Map")),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Container(
                width: 350, // กำหนดความกว้างของ Container
                height: 100, // กำหนดความสูงของ Container
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลังของ Container
                  border: Border.all(color: Colors.black, width: 1), // ขอบสีดำ
                  borderRadius: BorderRadius.circular(20), // โค้งขอบ
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/RegisterDemo.jpg',
                        width: 80, // กำหนดความกว้างของรูป
                        height: 80, // กำหนดความสูงของรูป
                        fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Username",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Text("080-xxx-xxxx",
                              style: TextStyle(color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(10), // โค้งขอบ
                          ),
                          child: Text(
                            "กย 1515",
                            style: TextStyle(
                              color: Colors.white, // สีขาว
                              fontWeight: FontWeight.bold, // ตัวหนา
                              fontSize:
                                  16.0, // ขนาดฟอนต์ (คุณสามารถปรับขนาดตามต้องการ)
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
              Column(
                children: [
                  Icon(
                    Icons.check_circle, // ไอคอนเครื่องหมายถูก
                    size: 30, // ขนาดของไอคอน
                    color: Color(0xFFFF7622), // สีของไอคอน
                  ),
                  Container(
                    width: 5, // ความกว้างของเส้น
                    height: 40, // ความสูงของเส้น
                    color: Color(0xFFFF7622), // สีของเส้น
                  ),
                  Icon(
                    Icons.check_circle, // ไอคอนเครื่องหมายถูกอีกครั้ง
                    size: 30, // ขนาดของไอคอน
                    color: Color(0xFFBFBCBA), // สีของไอคอน
                  ),
                  Container(
                    width: 5, // ความกว้างของเส้น
                    height: 40, // ความสูงของเส้น
                    color: Color(0xFFBFBCBA), // สีของเส้น
                  ),
                  Icon(
                    Icons.check_circle, // ไอคอนเครื่องหมายถูกอีกครั้ง
                    size: 30, // ขนาดของไอคอน
                    color: Color(0xFFBFBCBA), // สีของไอคอน
                  ),
                  Container(
                    width: 5, // ความกว้างของเส้น
                    height: 40, // ความสูงของเส้น
                    color: Color(0xFFBFBCBA), // สีของเส้น
                  ),
                  Icon(
                    Icons.check_circle, // ไอคอนเครื่องหมายถูกอีกครั้ง
                    size: 30, // ขนาดของไอคอน
                    color: Color(0xFFBFBCBA), // สีของไอคอน
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("รอไรเดอร์มารับสินค้า",
                      style: TextStyle(
                        color: Color(0xFFFF7622), // สีขาว
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  Text("ไรเดอร์รับงาน"),
                  SizedBox(
                    height: 50,
                  ),
                  Text("ไรเดอร์รับสินค้าแล้วและกำลังเดินทาง"),
                  SizedBox(
                    height: 50,
                  ),
                  Text("ไรเดอร์นำส่งสินค้าแล้ว"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
