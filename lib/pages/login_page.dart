import 'package:fcc/constants/routes.dart';
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
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        Navigator.pushNamedAndRemoveUntil(context, notesRoute, (_)=>false);
                      }
                      else{
                        showErrorDialog(context, "Please verify your email first");
                      }
                    }on FirebaseAuthException  catch (e) {
                       await showErrorDialog(context, e.code);
                    }catch(e){
                      await showErrorDialog(context, e.toString());
                    }
                  },
                  child: Text("Login"),
                ),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, registerRoute, (route)=>false);
                },  child: Text("Not registered yet? Register Now!!"))
              ],
            ),
          )
      );
    }
  }

  Future<void> showErrorDialog(BuildContext context,String errorMsg){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Text("Error!!"),
      content: Text(errorMsg),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text("OK"))
      ],
    );
  },
  );
  }