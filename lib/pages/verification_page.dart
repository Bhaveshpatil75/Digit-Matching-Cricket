import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Verification"),),
      body: Column(
        children: [
          const Text("Please verify your email first"),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: ()async{
            final user=FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
            Navigator.pushNamedAndRemoveUntil(context, "/login/", (_)=>false);
          }, child: const Text("Send verification email"))
        ],
      ),
    );
  }
}