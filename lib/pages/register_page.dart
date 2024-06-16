import 'package:fcc/constants/routes.dart';
import 'package:fcc/main.dart';
import 'package:fcc/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}


class _RegisterPage extends State<RegisterPage> {

  var em=TextEditingController();
  var ps=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

          backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: Text("Register"),
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
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: em.text,
                        password: ps.text
                    );
                    Navigator.pushNamedAndRemoveUntil(context, verifyRoute, (_)=>false);
                  } on FirebaseAuthException catch (e) {//catching the exception if creation of user fails
                    await showErrorDialog(context, e.code);  //various types of exception could be handled here. (like we did in Loginpage)
                  }catch(e){
                    await showErrorDialog(context, e.toString());
                  }
                },
                child: Text("Register"),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route)=>false);
              },  child: Text("Already registered? Login Now!!"))
            ],
          ),
        )
    );
  }
}
