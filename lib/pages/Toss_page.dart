import 'dart:math';
import 'package:fcc/dialogs/show_logout_dialog.dart';
import 'package:fcc/pages/Match_page.dart';
import 'package:fcc/pages/appBar.dart';
import 'package:fcc/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';

class TossPage extends StatefulWidget {
  const TossPage({super.key});

  @override
  State<TossPage> createState() => _TossPageState();
}

class _TossPageState extends State<TossPage> {

   late String toss;
  late bool once;
   String? tossWinner;
   late String userName;
  @override
  void initState() {
    toss="";
    once=true;
    userName=FirebaseAuth.instance.currentUser?.displayName??"User";
    if(userName.isEmpty){userName="User";}
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              Text("Welcome, ${userName??"User"}"),
              SizedBox(height: 10,),
              Text("TOSS",style: TextStyle(fontSize:50,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        Container(
          height: 100,
          child: Column(
            children: [
              Text("Make your call..."),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    if (once) {
                      once=false;
                      toss=Random().nextBool() ? "HEAD":"TAIL";
                      tossWinner=toss=="HEAD"? userName:"Computer";
                      setState(() {
                      });
                    }
                  }, child: Text("Head"),),
                  SizedBox(width: 50,),
                  ElevatedButton( onPressed: (){
                    if (once) {
                      once=false;
                      toss=Random().nextBool() ? "HEAD":"TAIL";
                      tossWinner=toss=="TAIL"? userName:"Computer";
                      setState(() {

                      });
                    }
                  }, child: Text("Tail"),),
                ],
              ),
            ],
          ),
        ),
        Text(!once?"TOSS: $toss":"",style: TextStyle(fontSize: 30),),
        SizedBox(height: 20,),
        Text(!once?"$tossWinner won the toss.":"",style: TextStyle(fontSize: 30),),
        Choice(tossWinner: tossWinner,userName: userName,),
      ]
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 200,
              child: DrawerHeader(
                      child: UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade200,
                          borderRadius: BorderRadius.circular(20)
                        ),
                  currentAccountPicture:CircleAvatar(
                  child: Text(userName.substring(0,1)),)
                  ,accountName: Text(userName) , accountEmail:Text(FirebaseAuth.instance.currentUser?.email??""))),
            ),
            ListTile(
              tileColor: Colors.deepPurple.shade100,
              title: Text("Log Out"),
              onTap: ()async{
                final isLoggedOut=await showDialogLogOut(context);
                if (isLoggedOut){
                  await AuthService.firebase().logOut();
                  Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route)=>false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Choice extends StatefulWidget {
   String? tossWinner;
   String userName;
   Choice({super.key,required this.tossWinner,required this.userName});

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  late String cch;
  late String uch;
 late  bool showContinue;
 late bool uBat;
  @override
  void initState() {
    cch=Random().nextBool()?"BAT":"BOWL";
    uch="";
    showContinue=false;
    uBat=false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.tossWinner=="Computer"){
      uBat=cch=="BOWL"?true:false;
      showContinue=true;
      setState(() {
      });
      return Column(
        children: [
          Text("and Chose to $cch First",style: TextStyle(fontSize: 20),),
          SizedBox(height: 20,),
          continueButton(showContinue),
        ],
      );
    }else if (widget.tossWinner==widget.userName){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                if (!showContinue) {
                  uch="BAT";
                  uBat=true;
                  setState(() {
                    showContinue=true;
                  });
                }
              }, child: Text("BAT")),
              ElevatedButton(onPressed: (){
                if (!showContinue) {
                  uch="BOWL";
                  setState(() {
                    showContinue=true;
                  });
                }
              }, child: Text("BOWL")),
            ],
          ),
          Text(showContinue?"and chose to $uch First":"",style: TextStyle(fontSize: 20),),
          SizedBox(height: 20,),
          continueButton(showContinue),
        ],
      );
    }else
      return Container();
  }
  Widget continueButton(sc){
    if (sc) {
      return ElevatedButton(onPressed: ()async{
       // await DatabaseService( uid: FirebaseAuth.instance.currentUser!.uid).update_global("player", 6, 'name', DateTime.now());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MatchPage(uBat: uBat,)),(_)=>false);
      }, child: Text("Continue"));
    }else return Container();
  }
}