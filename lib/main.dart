
import 'package:fcc/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RoutePage(),
    );
  }
}

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Route"),backgroundColor: Colors.blue,),
      body: FutureBuilder(
        future: Firebase.initializeApp(  //initialising
        options: DefaultFirebaseOptions.currentPlatform
        ),
        builder: (context, snapshot) { //snapshots are like real time states from the future of FutureBuilder
          switch(snapshot.connectionState) {  //switching cases a/c to state of connection of snapshot
            case ConnectionState.done: //in case if connection is established
            final curUser=FirebaseAuth.instance.currentUser;
            final _verified= curUser?.emailVerified ?? false;
            if (_verified) {
              print("Good you a verified user");
            }
            else{
              print(curUser?.email);
              print("You need to verify your email first");
            }
            return Text("Done");
            default:  //all other cases such as none and so on
              return Text("Loading....");
          }
        },
      )
    );
  }
}

