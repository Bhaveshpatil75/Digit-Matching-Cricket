
import 'package:fcc/constants/routes.dart';
import 'package:fcc/pages/login_page.dart';
import 'package:fcc/pages/notes_page.dart';
import 'package:fcc/pages/register_page.dart';
import 'package:fcc/pages/verification_page.dart';
import 'package:fcc/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log; //will only import log functionality from the package instead of the whole package



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
        '/routing/':(context)=>RoutePage(),
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
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) { //snapshots are like real time states from the future of FutureBuilder
          switch(snapshot.connectionState) {  //switching cases a/c to state of connection of snapshot
            case ConnectionState.done: //in case if connection is established
              final curUser=AuthService.firebase().currentUser;
              if (curUser != null) {
                if (curUser.isEmailVerified) {
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








