import 'package:flutter/material.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.85,
              child: Image.asset(
                'assets/images/UserBg.jpg',
                width: double.infinity,
                fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 600,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.elliptical(200, 50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'ค้นหาผู้ที่ต้องการจัดส่ง',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // ใช้ ListView ในการแสดงผลการ์ดโปรไฟล์หลายรายการ
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(8),
                            children: [
                              _buildProfileCard(
                                  "สมชาย ลายสุด", "3 KM", "30 \$"),
                              SizedBox(height: 10),
                              _buildProfileCard(
                                  "สมหญิง แสนสุข", "4 KM", "40 \$"),
                              SizedBox(height: 10),
                              _buildProfileCard("โพธิ์รัตน์", "3 KM", "30 \$"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ฟังก์ชันสร้างการ์ดโปรไฟล์
  Widget _buildProfileCard(String name, String distance, String price) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/UserProfile.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ระยะทาง", style: TextStyle(color: Colors.blueGrey)),
                      Text("ค่าจัดส่ง",
                          style: TextStyle(color: Colors.blueGrey)),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(distance, style: TextStyle(color: Colors.blueGrey)),
                      Text(price, style: TextStyle(color: Colors.blueGrey)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7622),
            ),
            child: Text("เลือก"),
          ),
        ],
      ),
    );
  }
}
