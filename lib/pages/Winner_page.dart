
import 'package:fcc/pages/appBar.dart';
import 'package:flutter/material.dart';

class WinnerPage extends StatefulWidget {
  String? matchWinner;
  WinnerPage({super.key,required this.matchWinner});

  @override
  State<WinnerPage> createState() => _WinnerPageState();
}

class _WinnerPageState extends State<WinnerPage> {

  @override
  Widget build(BuildContext context) {
    String msg=widget.matchWinner=="tie"? "Match Tied":"${widget.matchWinner} won the match";
    return Scaffold(
      appBar: appBar(context),
      body: Center(child: Text("$msg",style: TextStyle(fontSize: 30),))
    );
  }
}
