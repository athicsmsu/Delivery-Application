import 'package:delivery_application/pages/rider/homeRider.dart';
import 'package:delivery_application/pages/rider/settingRider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MenuRiderPage extends StatefulWidget {
  const MenuRiderPage({super.key});

  @override
  State<MenuRiderPage> createState() => _MenuRiderPageState();
}

class _MenuRiderPageState extends State<MenuRiderPage> {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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