import 'dart:developer';

import 'package:delivery_application/pages/user/homeUser.dart';
import 'package:delivery_application/pages/user/profileUser.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MainUserPage extends StatefulWidget {
  const MainUserPage({super.key});

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {
  int _selectedIndex = 0;
  Widget currentPage = const HomeUserPage();

  void _onItemTapped(int index) {
    if (index == 0) {
      currentPage = const HomeUserPage();
      log('message');
    } else if (index == 1) {
    } else if (index == 2) {
    } else if (index == 3) {
      currentPage = const ProfileUserPage();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  icon: FaIcon(FontAwesomeIcons.truck),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.boxesStacked),
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
              onTap: _onItemTapped,
              showSelectedLabels: false, // ซ่อนข้อความเมื่อเลือก
              showUnselectedLabels: false, // ซ่อนข้อความเมื่อไม่ถูกเลือก
            ),
          ),
        ),
      ),
    );
  }
}
