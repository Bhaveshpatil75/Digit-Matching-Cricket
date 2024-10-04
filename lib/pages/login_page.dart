import 'package:fcc/constants/routes.dart';
import 'package:fcc/pages/Match_page.dart';
import 'package:fcc/pages/Toss_page.dart';
import 'package:fcc/services/auth/auth_service.dart';
import 'package:fcc/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    late bool loading,showPass;
    @override
  void initState() {
      loading=showPass=false;
    super.initState();
  }

    @override
    Widget build(BuildContext context) {
      return loading?Loading():Scaffold(
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
                  obscureText: !showPass,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(onPressed: () {
                      setState(() {
                        showPass=!showPass;
                      });
                    }, icon: Icon(showPass?Icons.remove_red_eye:Icons.remove_red_eye_outlined),),
                  ),
                ),
                Wrap(
                  spacing:50,
                  children:[
                    TextButton(onPressed: ()async{
                      try {
                        setState(() {
                          loading=true;
                        });
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: em.text ?? "");
                        await showScorecard(context, "Email Sent", "Password reset email is sent on ${em.text}");
                        setState(() {
                          loading=false;
                        });
                      }on FirebaseAuthException catch (e){
                        loading=false;
                        if (e.code=="user-not-found"){await showErrorDialog(context, "User Not Found");}
                        else await showErrorDialog(context, "Problem in servers");
                      }catch(e){
                        loading=false;
                        await showErrorDialog(context, "Something went wrong");
                      }
                    }, child: Text("Forgot Password??"))
                    ,ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          loading=true;
                        });
                        await AuthService.firebase().logIn(
                            email: em.text,
                            password: ps.text
                        );
                        if (AuthService.firebase().currentUser!.isEmailVerified) {
                          Navigator.pushNamedAndRemoveUntil(context, tossRoute, (_)=>false);
                        }
                        else{
                          await showErrorDialog(context, "Verify your Email first");
                          Navigator.of(context).pushNamed(verifyRoute);
                        }
                      }on UserNotFoundAuthException{
                        await showErrorDialog(context, "User Not Found");
                        setState(() {
                          loading=false;
                        });
                      }on WrongPasswordAuthException{
                        await showErrorDialog(context, "Wrong Password");
                        setState(() {
                          loading=false;
                        });
                      }on GenericAuthException{
                        await showErrorDialog(context, "Something went Wrong!!");
                        setState(() {
                          loading=false;
                        });
                      }
                    },
                    child: Text("Login"),
                  ),
                  ]
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

