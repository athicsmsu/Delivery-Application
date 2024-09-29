import 'package:delivery_application/pages/user/homeUser.dart';
import 'package:delivery_application/pages/user/receiveItem.dart';
import 'package:delivery_application/pages/user/settingUser.dart';
import 'package:delivery_application/pages/user/shippingItem.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuUserPage extends StatefulWidget {
  const MenuUserPage({super.key});

  @override
  State<MenuUserPage> createState() => _MenuUserPageState();
}

class _MenuUserPageState extends State<MenuUserPage> {
  int _selectedIndex = 0;
  Widget currentPage = const HomeUserPage();
  List<Widget> pageStack = [const HomeUserPage()];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        currentPage = const HomeUserPage();
      } else if (index == 1) {
        currentPage = const ShippingItemPage();
      } else if (index == 2) {
        currentPage = const ReceiveItemPage();
      } else if (index == 3) {
        currentPage = const SettingUserPage();
      }
      pageStack.add(currentPage); // Add to history stack when navigating
    });
  }

  void goBack() {
    if (pageStack.length > 1) {
      setState(() {
        pageStack.removeLast(); // Remove current page
        currentPage = pageStack.last; // Set previous page
        // Update the selected index based on the currentPage
        if (currentPage.runtimeType == HomeUserPage) {
          _selectedIndex = 0;
        } else if (currentPage.runtimeType == ShippingItemPage) {
          _selectedIndex = 1;
        } else if (currentPage.runtimeType == ReceiveItemPage) {
          _selectedIndex = 2;
        } else if (currentPage.runtimeType == SettingUserPage) {
          _selectedIndex = 3;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFFF),
        appBar: _selectedIndex == 0 || _selectedIndex == 3
            ? null // ไม่แสดง AppBar เมื่ออยู่ในหน้า Home
            : AppBar(
                title: Text(
                  _selectedIndex == 1 ? 'รายการส่งสินค้า' : 'รายการรับสินค้า',
                  style: TextStyle(
                    fontSize: Get.textTheme.titleLarge!.fontSize,
                    color: Colors.black,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    // letterSpacing: 1
                  ),
                ),
                backgroundColor: const Color(0xFFFFFFFF),
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
                type: BottomNavigationBarType.fixed,
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
                currentIndex: _selectedIndex, //เปลี่ยนสีตาม _selectedIndex
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
      ),
    );
  }
  //   @override
  // void dispose() {
  //   if (context.read<Appdata>().listener != null) {
  //     context.read<Appdata>().listener!.cancel();
  //     context.read<Appdata>().listener = null;
  //   } // ยกเลิกการฟัง Stream ก่อน widget จะถูกลบ
  //   super.dispose();
  // }
}
