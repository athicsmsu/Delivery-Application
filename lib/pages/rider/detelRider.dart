import 'package:flutter/material.dart';

class DetelRiderPage extends StatefulWidget {
  const DetelRiderPage({super.key});

  @override
  State<DetelRiderPage> createState() => _DetelRiderPageState();
}

class _DetelRiderPageState extends State<DetelRiderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // กำหนดให้มุมโค้ง
              child: Image.asset(
                'assets/images/RiderHome.jpg',
                width: 350, // กำหนดความกว้าง
                height: 200, // กำหนดความสูง
                fit: BoxFit.cover, // ปรับขนาดให้เต็มพื้นที่
              ),
            ),
            Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของ Container
                border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                borderRadius: BorderRadius.circular(20), // โค้งขอบ
              ),
              child: Text(""),
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
                    border: Border.all(color: Colors.black, width: 2), // ขอบสีดำ
                    borderRadius: BorderRadius.circular(20), // โค้งขอบ
                  ),
                  child: Text(""),
                ),
              ],
            ),
            FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFE53935)),
                  minimumSize: MaterialStateProperty.all(Size(400, 50)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // ทำให้ขอบมน
                  )),
                ),
                child: Text("ถัดไป"))
          ],
        ),
      ),
    );
  }
}
