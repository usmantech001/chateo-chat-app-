import 'package:chateo/view/bottom_nav/chat_screen.dart';
import 'package:chateo/view/bottom_nav/contact_screen.dart';
import 'package:chateo/view/bottom_nav/more_screen.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController{
  int currentIndex = 0;

  List screens = const[
    ChatScreen(),
    ContactScreen(),
    MoreScreen()
  ];
  changeCurrentIndex(int index){
    currentIndex = index;
    update();
  }
}