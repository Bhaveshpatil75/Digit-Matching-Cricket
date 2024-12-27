import 'dart:async';
import 'package:fcc/pages/inbetween.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Toss_page.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() { //managing the state initially
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      SharedPreferences prefs=await SharedPreferences.getInstance();
      String? name=prefs.getString("name");
      if (name==null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NameInputPage()));  //calling homepage from old_main1.dart
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>TossPage(username: name)));
      }
    });//using pushReplacement will not add splash_page to stack hence when user hits back from homepage he will be exited directly rather than switching to splashPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Colors.deepPurple[200],
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("DIGIT MATCHING CRICKET",style: TextStyle(fontSize: 26,fontFamily: "Font1",color: Colors.black,fontWeight: FontWeight.bold),),
            Image.asset("assets/cricket.png")
          
          ],
        )),
      ),
    );
  }
}