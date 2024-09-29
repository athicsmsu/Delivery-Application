import 'package:delivery_application/pages/rider/homeRider.dart';
import 'package:delivery_application/pages/rider/settingRider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MainRiderPage extends StatefulWidget {
  const MainRiderPage({super.key});

  @override
  State<MainRiderPage> createState() => _MainRiderPageState();
}

class _MainRiderPageState extends State<MainRiderPage> {
    int _selectedIndex = 0;
  Widget currentPage = const homeRiderPage();
   List<Widget> pageStack = [const homeRiderPage()];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        currentPage = const homeRiderPage();
      } else if (index == 1) {
        currentPage = const SettingRiderPage();
      }
      pageStack.add(currentPage); // Add to history stack when navigating
    });
  }

  void goBack() {
    if (pageStack.length > 1) {
      setState(() {
        pageStack.removeLast(); // Remove current page
        currentPage = pageStack.last; // Set previous page
        _selectedIndex = 0; // Reset tab index as necessary
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? null // ไม่แสดง AppBar เมื่ออยู่ในหน้า Home
          : AppBar(
              backgroundColor: Colors.transparent, // ทำให้สีโปร่งใส
              elevation: 0, // ปรับให้ไม่มีเงา
              leading: IconButton(
                icon: const Icon(Icons.arrow_back), // ปุ่ม Back
                onPressed: goBack, // เรียกฟังก์ชันย้อนกลับเมื่อกด
              ),
            ),
      body: currentPage,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.textTheme.bodyMedium!.fontSize!),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // สีพื้นหลังของ BottomNavigationBar
            borderRadius: BorderRadius.circular(30), // ทำขอบมน
            boxShadow: const [
              BoxShadow(
                color: Colors.black26, // เงาของขอบ
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight:
                    Radius.circular(8)), // ทำขอบมนให้กับ BottomNavigationBar
            child: BottomNavigationBar(
              // type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.solidUser),
                  label: '',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xFFE53935),
              unselectedItemColor: Colors.black,
              backgroundColor:
                  Colors.white, // สีพื้นหลังของ BottomNavigationBar
              iconSize: Get.textTheme.headlineMedium!.fontSize!,
              onTap: onItemTapped,
              showSelectedLabels: false, // ซ่อนข้อความเมื่อเลือก
              showUnselectedLabels: false, // ซ่อนข้อความเมื่อไม่ถูกเลือก
            ),
          ),
        ),
      ),
    );
  }
}