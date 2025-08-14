import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_app/pages/home_page.dart';


class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();

}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {

    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent.shade100,
        child: Center(
            child: Image.asset('assets/images/skilltrack.PNG', width: 200, height: 200,))

      ),
    );
  }
}
