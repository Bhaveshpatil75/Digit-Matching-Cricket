import 'package:fcc/constants/routes.dart';
import 'package:fcc/services/auth/auth_exceptionss.dart';
import 'package:fcc/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../dialogs/show_error_dialog.dart';

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
                    await AuthService.firebase().createUser(
                        email: em.text,
                        password: ps.text
                    );
                    final user=AuthService.firebase().currentUser;
                     AuthService.firebase().sendVerificationMail();
                    Navigator.pushNamed(context,verifyRoute);
                  } on EmailAlreadyInUseAuthException {//catching the exception if creation of user fails
                    await showErrorDialog(context, "Email already Taken");  //various types of exception could be handled here. (like we did in Loginpage)
                  }on WeakPasswordAuthException{
                    await showErrorDialog(context, "Password is too Weak");
                  }on InvalidEmailAuthException{
                    await showErrorDialog(context, "Invalid Email");
                  }on GenericAuthException {
                    await showErrorDialog(context, "Something went wrong!!");
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
