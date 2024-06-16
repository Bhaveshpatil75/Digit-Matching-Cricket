import 'package:fcc/constants/routes.dart';
import 'package:fcc/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../dialogs/show_error_dialog.dart';
import '../services/auth/auth_exceptionss.dart';

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
                      await AuthService.firebase().logIn(
                          email: em.text,
                          password: ps.text
                      );
                      if (AuthService.firebase().currentUser!.isEmailVerified) {
                        Navigator.pushNamedAndRemoveUntil(context, notesRoute, (_)=>false);
                      }
                      else{
                        showErrorDialog(context, "Verify your Email first");
                        Navigator.of(context).pushNamed(verifyRoute);
                      }
                    }on UserNotFoundAuthException{
                      await showErrorDialog(context, "User Not Found");
                    }on WrongPasswordAuthException{
                      await showErrorDialog(context, "Wrong Password");
                    }on GenericAuthException{
                      await showErrorDialog(context, "Something went Wrong!!");
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

