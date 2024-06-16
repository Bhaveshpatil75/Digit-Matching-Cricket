import 'package:fcc/constants/routes.dart';
import 'package:fcc/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Verification"),),
      body: Column(
        children: [
          const Text("We've sent you a verification mail"),
          SizedBox(height: 10,),
          const Text("If mail not received click the button below"),
          ElevatedButton(onPressed: ()async{
            final user=AuthService.firebase().currentUser;
              await AuthService.firebase().sendVerificationMail();
          }, child: const Text("Send verification email AGAIN " )),
          SizedBox(height: 20,),
          Text("Proceed to login if you verified your email"),
          ElevatedButton(onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context,loginRoute, (_)=>false);
          }, child: Text("Login"))
        ],
      ),
    );
  }
}