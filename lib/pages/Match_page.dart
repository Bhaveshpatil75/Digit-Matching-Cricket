
import 'dart:math';
import 'package:fcc/pages/appBar.dart';
import 'package:fcc/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth/database_service.dart';

class MatchPage extends StatefulWidget {
  late bool uBat;
  MatchPage({super.key,required this.uBat,});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {

  late int uScore,cScore,uCall,cCall,hs;
  late bool uChaser;
   String? matchWinner;
   late String user,winMsg;
   late bool secondInning;
   late bool uBat1,loading,done;
   late List<bool> onceGlory;
  final DatabaseService db=DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);


  @override
  void initState() {
    uScore=cScore=uCall=cCall=hs=0;
    uChaser=widget.uBat? false:true;
    user=FirebaseAuth.instance.currentUser?.displayName ?? "User";
    if (user.isEmpty){user="User";}
    secondInning=loading=done=false;
    winMsg="";
    uBat1=widget.uBat;
    onceGlory=[true];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
        appBar: appBar(context),
        body: StreamBuilder<List<Global>>(
          stream: db.globalData,
          builder: (context, snapshot) {
            final data=snapshot.data?.toList();
            data!=null? hs=data[0].highScore:0;
            print(hs);
            return Column(
                children: [
                  Container(
                    height: 300,
                    margin: EdgeInsets.all(30),
                    padding: EdgeInsets.all(30),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(user,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              Text(uBat1?"Batting":"Bowling"),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2)),
                                  child: Center(child: Text("$uScore",style: TextStyle(fontSize: 30),)),
                                ),
                              ),
                              Text('$uCall'),
                              Text("Your call")
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text('Computer',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              Text(uBat1?"Bowling":"Batting"),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2)),
                                  child: Center(child: Text("$cScore",style: TextStyle(fontSize: 30),)),
                                ),
                              ),
                              Text("$cCall"),
                              Text("Computer call")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    spacing: 10,
                    children:[ Wrap(
                      spacing:10,
                      children: [
                        ElevatedButton(onPressed: (){
                          !done?setState(() {
                            update(context,1,user);
                          }):null;
                        }, child: Text("1")),
                        ElevatedButton(onPressed: (){
                          !done?setState(() {
                            update(context,2,user);
                          }):null;
                        }, child: Text("2")),
                        ElevatedButton(onPressed: (){
                          !done?setState(() {
                            update(context,3,user);
                          }):null;
                        }, child: Text("3")),
                      ],
                    ),
                      Wrap(
                        spacing:20,
                        children: [
                          ElevatedButton(onPressed: (){
                            !done?setState(() {
                              update(context,4,user);
                            }):null;
                          }, child: Text("4")),
                          ElevatedButton(onPressed: (){
                            !done?setState(() {
                              update(context,6,user);
                            }):null;
                          }, child: Text("6")),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(done? winMsg:"",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                ]
            );
          }
        ),
    );
  }
  int Randi(){
    var lis=[1,2,3,4,6];
    int ind=Random().nextInt(5);
    return lis[ind];
  }
  void update(BuildContext context,int u,String user)async{
    int c=Randi();
    uCall=u;
    cCall=c;
    //db.update_global("player", 0, "name", DateTime.now());
    if (widget.uBat){
      if (u==c){
        await showScorecard(context, "OUT!!!", secondInning?"$user is out on $uScore":"$user is out on $uScore. Target for Computer is ${uScore+1}");
        if (secondInning && uScore==cScore){
          matchWinner="tie";
          winMsg="Match Tied";
        } else {
          if (!secondInning) {
            uBat1=false;
            setState(() {
            });
          }
          widget.uBat=false;
          secondInning=true;
          if (uScore<cScore){
            matchWinner="Computer" ;
            winMsg="Computer won by ${cScore-uScore} Runs";
          }
        }
      }else{
        uScore+=u;
        checkGlory(context,uScore,user);
      }
    }else{
      if (u==c){
        await showScorecard(context, "OUT!!!", secondInning?"Computer is out on $cScore":"Computer is out on $cScore. Target for $user is ${cScore+1}");
        if (secondInning && uScore==cScore){
          matchWinner="tie";
          winMsg="Match Tied";
        } else {
          if (!secondInning) {
            uBat1=true;
            setState(() {
            });
          }
          widget.uBat =true;
          secondInning=true;
          if (uScore>cScore){
            matchWinner=user;
            winMsg="$user won by ${uScore-cScore} Runs";
          }
        }
      }else{
        cScore+=c;
        checkGlory(context,cScore,"Computer");
      }
    }
    Check(context,user);
  }
  void Check(BuildContext context,String user)async{
    if (uChaser){
      if (uScore>cScore){
        winMsg="$user won while chasing";
        matchWinner=user;
      }
    }else{
      if (cScore>uScore){
        matchWinner="Computer";
        winMsg="Computer won while chasing";
      }
    }
    if (matchWinner!=null){
      done=true;
      await showScorecard(context, "Match Completed!!!", winMsg);
      try{
        setState(() {
          loading=true;
        });
        print("above data");
            if (hs<max(uScore, cScore)) {
              print("2nd");
              await db.update_global(user,max(uScore, cScore), matchWinner??"", DateTime.now());
              print("here");
            }
        await db.update(uScore, cScore, winMsg, DateTime.now());
           // await db.update_try("h");
        setState(() {
          loading=false;
        });
      }catch(e){
        //print(e.toString());
        setState(() {
        loading=false;
      });}
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>WinnerPage(matchWinner: matchWinner)),);
    }
  }
  void checkGlory(BuildContext context,int score,String name)async{
    int ind=(score/50) as int;
    if (onceGlory[0]){
      score>=50?await showScorecard(context, "Fifty!!!", "Fifty for $name"):null;
      onceGlory[0]=false;
      onceGlory.add(true);
    }else if(onceGlory[1]){
      score>=100?await showScorecard(context, "Century!!!", "Century for $name"):null;
      onceGlory[1]=false;
      onceGlory.add(true);
    }else if(onceGlory[ind-1]){
      await showScorecard(context, "${50*ind}", "${50*ind} for $name");
      onceGlory[ind-1]=false;
      onceGlory.add(true);
    }
  }
}

Future<void> showScorecard(BuildContext context,String title,String content)async{
  return showDialog(context: context,
    builder: (BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Continue"))
      ],
    );
    },
  );
}
