import 'package:chateo/constants/constants.dart';
import 'package:chateo/controller/bttom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
      builder: (bottomNavController) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: bottomNavController.screens[bottomNavController.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: bottomNavController.changeCurrentIndex,
            selectedItemColor: AppColors.MainColor,
            currentIndex: bottomNavController.currentIndex,
            elevation: 0,
            items: [
              BottomNavigationBarItem(icon: Image.asset('assets/images/chats.png', height: 40,), label: 'Chats'),
              BottomNavigationBarItem(icon: Image.asset('assets/images/contact.png', height: 40,), label: 'Contacts'),
              BottomNavigationBarItem(icon: Image.asset('assets/images/more.png', height: 40,), label: 'Mre'),

            ]
            ),
        );
      }
    );
  }
}