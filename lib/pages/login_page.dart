import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

    var em=TextEditingController();
    var ps=TextEditingController();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("Login"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: em,
                    decoration: InputDecoration(
                      hintText: "Email",
                    )
                ),
                TextField(
                  controller: ps,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: em.text,
                          password: ps.text
                      );
                      print("Logged in");
                    }on FirebaseAuthException  catch (e) {
                      if (e.code =="invalid-credential")
                        print("wrong pass");
                    }
                  },
                  child: Text("Login"),
                ),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, "/register/", (route)=>false);
                },  child: Text("Not registered yet? Register Now!!"))
              ],
            ),
          )
      );
    }
  }
