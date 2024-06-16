
import 'package:fcc/constants/routes.dart';
import 'package:fcc/pages/login_page.dart';
import 'package:fcc/pages/register_page.dart';
import 'package:fcc/pages/verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log; //will only import log functionality from the package instead of the whole package
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
      routes: {
        loginRoute:(context)=>LoginPage(),
        registerRoute:(context)=>RegisterPage(),
        notesRoute:(context)=>NotesPage(),
        verifyRoute:(context)=>VerifyPage(),
      },
    );
  }
}

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: Firebase.initializeApp(  //initialising
            options: DefaultFirebaseOptions.currentPlatform
        ),
        builder: (context, snapshot) { //snapshots are like real time states from the future of FutureBuilder
          switch(snapshot.connectionState) {  //switching cases a/c to state of connection of snapshot
            case ConnectionState.done: //in case if connection is established
              final curUser=FirebaseAuth.instance.currentUser;
              if (curUser != null) {
                if (curUser.emailVerified) {
                  return const NotesPage();
                } else {
                  return const VerifyPage();
                }
              }
              else{
                return const LoginPage();
              }

            default:  //all other cases such as none and so on
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

enum MenuAction{logout}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Content"),
        actions: [
          PopupMenuButton<MenuAction>(itemBuilder: (value){
            return [PopupMenuItem(child: Text("Log out"),value: MenuAction.logout,)];
          },
            onSelected: (value)async{
            final loggedOut= await showDialogLogOut(context);
            if (loggedOut){
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route)=>false);
            }
            },
          )
        ],
      ),
      body: Container(
        child:Center(
            child:Text("Main Content.")
        ),
      ),
    );
  }
}

Future<bool> showDialogLogOut(BuildContext context){
  return showDialog<bool>(context: context, builder: (context){
    return AlertDialog(
      title: Text("Log Out!!"),
       content: Text("Are you sure you want to Log out??"),
       actions: [
         TextButton(onPressed: (){
           Navigator.of(context).pop(false);
         }, child: Text("Cancel")),
         TextButton(onPressed: (){
           Navigator.of(context).pop(true);
         },  child:Text("Log out")),
       ],
    );
  }
  ).then((value)=> value ?? false);
}





