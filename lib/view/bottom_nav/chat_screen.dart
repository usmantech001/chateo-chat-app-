import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: bigText(text: 'Chat'),
      ),
    );
  }
}