import 'package:flutter/material.dart';

class homeRiderPage extends StatefulWidget {
  const homeRiderPage({super.key});

  @override
  State<homeRiderPage> createState() => _homeRiderPageState();
}

class _homeRiderPageState extends State<homeRiderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ClipRect(
            child: Align(
              heightFactor:
                  0.8,
              child: Image.asset(
                'assets/images/RiderHome.jpg',
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
                    Container(
                        width: 400, // กำหนดความกว้างของ Container
                        height: 150, // กำหนดความสูงของ Container
                        decoration: BoxDecoration(
                          color: Colors.white, // สีพื้นหลังของ Container
                          border: Border.all(
                              color: Colors.black, width: 2), // ขอบสีดำ
                          borderRadius: BorderRadius.circular(20), // โค้งขอบ
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/RiderHome.jpg',
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
                                  onPressed: () {
                                                    
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                         const Color(0xFF56DA40)), // กำหนดสีพื้นหลัง
                                  ),
                                  child:  const Text("รับออร์เดอร์"),
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
