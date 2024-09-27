import 'dart:developer';

import 'package:delivery_application/pages/user/detailUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  TextEditingController searchCtl = TextEditingController();
  List<String> SearchList = []; // ลิสต์สำหรับเก็บรายการค้นหา
  late Future<void> loadData;
  var searchStatus = true;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

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
            child: Container(
              width: double.infinity,
              height: Get.height / 1.5,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius:
                    BorderRadius.vertical(top: Radius.elliptical(200, 50)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: Get.textTheme.displaySmall!.fontSize!),
                child: Column(
                  children: [
                    SizedBox(
                      width: Get.width - 50,
                      child: TextField(
                        controller: searchCtl,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: Get.textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'ค้นหาผู้ที่ต้องการจัดส่ง',
                          filled: true,
                          fillColor: const Color(0xFFEBEBEB),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                Search();
                              },
                              child: const Icon(Icons.search)),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                              10), // จำกัดตัวเลขที่ป้อนได้สูงสุด 10 ตัว
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: FutureBuilder(
                        future: loadData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              children: [
                                SizedBox(height: Get.height / 10),
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  SizedBox(height: Get.height / 10),
                                  Text(
                                    'เกิดข้อผิดพลาดในการโหลดข้อมูล',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: Get.textTheme.headlineSmall!
                                          .fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (searchStatus) {
                            return Column(
                              children: [
                                SizedBox(height: Get.height / 10),
                                Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    size: Get.height / 10,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Get
                                        .textTheme.headlineSmall!.fontSize!,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ค้นหาคนที่คุณจะส่งสินค้าสิ',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.poppins()
                                            .fontFamily,
                                        fontSize: Get.textTheme
                                            .headlineSmall!.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (SearchList.isEmpty) {
                            return Column(
                              children: [
                                SizedBox(height: Get.height / 10),
                                Center(
                                  child: FaIcon(
                                    FontAwesomeIcons
                                        .personCircleExclamation,
                                    size: Get.height / 10,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Get
                                        .textTheme.headlineSmall!.fontSize!,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ไม่พบผู้ใช้ที่ค้นหา',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.poppins()
                                            .fontFamily,
                                        fontSize: Get.textTheme
                                            .headlineSmall!.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SingleChildScrollView(
                              child: Column(
                                children: SearchList.map((users) => 
                                        buildProfileCard(
                                            "สมชาย ลายสุด", "3 KM", "30 \$"))
                                    .toList(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> loadDataAsync() async {
    // var value = await Configuration.getConfig();
    // url = value['apiEndpoint'];
    // var data = await http.get(Uri.parse('$url/lottery/allnotSold'));
    // lottoList = lottoAllGetResFromJson(data.body);
    // status = 'canBuy';
    setState(() {});
  }

  void Search() {
    searchStatus = false;
    log(searchCtl.text);
    SearchList.add("100");
    setState(() {});
  }

  // ฟังก์ชันสร้างการ์ดโปรไฟล์
  Widget buildProfileCard(String name, String distance, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.textTheme.titleMedium!.fontSize!,vertical: Get.textTheme.labelSmall!.fontSize!),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Get.textTheme.titleMedium!.fontSize!,
            horizontal: Get.textTheme.titleMedium!.fontSize!),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          border: Border.all(
              color: const Color.fromARGB(127, 153, 153, 153), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/UserProfile.jpg',
                width: Get.height / 9,
                height: Get.height / 9,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                    )),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ระยะทาง",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleSmall!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF747783),
                            )),
                        Text("ค่าจัดส่ง",
                            style: TextStyle(
                              fontSize: Get.textTheme.titleSmall!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF747783),
                            )),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(distance,
                            style: TextStyle(
                              fontSize: Get.textTheme.titleSmall!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF747783),
                            )),
                        Text(price,
                            style: TextStyle(
                              fontSize: Get.textTheme.titleSmall!.fontSize,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF747783),
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            FilledButton(
                onPressed: () {
                  log('เลือก');
                  Get.to(() => detailUserPage());
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(
                      Get.textTheme.titleLarge!.fontSize! * 2,
                      Get.textTheme.titleMedium!.fontSize! *
                          2)), // กำหนดขนาดของปุ่ม
                  backgroundColor: MaterialStateProperty.all(
                      const Color(0xFFFF7622)), // สีพื้นหลังของปุ่ม
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0), // ทำให้ขอบมน
                  )),
                ),
                child: Text('เลือก',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleSmall!.fontSize,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF),
                    ))),
          ],
        ),
      ),
    );
  }
}
