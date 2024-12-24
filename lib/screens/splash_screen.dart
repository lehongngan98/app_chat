import 'package:app_chat/main.dart';
import 'package:app_chat/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // enter full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      
      body: Stack(children: [
        AnimatedPositioned(
            top: mq.height * .40,
            left: mq.width * .3,
            width: mq.width * .4,
            duration: const Duration(seconds: 1),
            child: Image.asset('images/chat.png')),       
      ]),
    );
  }
}
