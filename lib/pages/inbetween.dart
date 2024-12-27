
import 'package:fcc/pages/Toss_page.dart';
import 'package:fcc/pages/appBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth/auth_service.dart';

class NameInputPage extends StatefulWidget {
  @override
  _NameInputPageState createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  final TextEditingController _controller = TextEditingController();
  final user=FirebaseAuth.instance.currentUser;

  @override
  void initState() {
   initFlutter();
    super.initState();
  }
  Future<void> initFlutter()async{
    await AuthService.firebase().logIn(
        email: "bhaveshpatil7504@gmail.com",
        password: "12345678"
    );
  }

 Future<void> submitName(BuildContext context) async{
    final name = _controller.text;
    if (name.isNotEmpty) {
      SharedPreferences prefs=await SharedPreferences.getInstance();
      prefs.setString("name", name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hello, $name!"),
          backgroundColor: Colors.green,
        ),

      );
      user?.updateDisplayName(name);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> TossPage(username: name,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text("Welcome to DMC")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'What\'s your name?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()async{
                await submitName(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.deepPurple[400],
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
