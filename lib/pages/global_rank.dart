
import 'package:fcc/pages/appBar.dart';
import 'package:fcc/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth/database_service.dart';

class GlobalRank extends StatelessWidget {
  const GlobalRank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: Ranks()
      );
  }
}
class Ranks extends StatelessWidget {
  const Ranks({super.key});


  @override
  Widget build(BuildContext context) {
    final DatabaseService db=DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    final DateFormat format=DateFormat("dd/MM/yyyy").add_jm();
    return StreamBuilder<List<Global>>(
      stream: db.globalData,
      builder: (context, snapshot)  {
         switch(snapshot.connectionState){
           case ConnectionState.waiting:
             return Loading();
           case ConnectionState.none:
             return Center(child: Text("Unable to fetch data"));
             default:
               final data=snapshot.data?.toList();
             return data==null?Text("Nothing to show here"):SizedBox(
             height: 300,
             child: Center(
         child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
         Text("Player : ${data?[0].player}"),
         Text("High Score : ${data?[0].highScore}"),
         Text("High Scorer : ${data?[0].name}"),
         Text("Played on : ${format.format(data?[0].dt.toDate()) }"),
         ],
         ),
         ),
         );
        }
      }
    );
  }
}

