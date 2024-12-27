import 'dart:math';
import 'package:fcc/dialogs/show_logout_dialog.dart';
import 'package:fcc/pages/Match_page.dart';
import 'package:fcc/pages/appBar.dart';
import 'package:fcc/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TossPage extends StatefulWidget {
  String username="User";
   TossPage({super.key,required this.username});

  @override
  State<TossPage> createState() => _TossPageState();
}

class _TossPageState extends State<TossPage> {
  late String toss;
  late bool once;
  String? tossWinner;
  late String userName;

  @override
  void initState() {
    super.initState();
    toss = "";
    once = true;
    //userName = FirebaseAuth.instance.currentUser?.displayName ?? "User";
    userName=widget.username;
    if (userName.isEmpty) {
      userName = "User";
    }
  }

  void handleTossCall(String call) {
    if (once) {
      setState(() {
        once = false;
        toss = Random().nextBool() ? "HEAD" : "TAIL";
        tossWinner = toss == call ? userName : "Computer";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,null),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Text(
                  "Welcome, $userName",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Text(
                  "TOSS",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Make your call...",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularButton(
                label: "H",
                onPressed: () => handleTossCall("HEAD"),
              ),
              SizedBox(width: 60),
              CircularButton(
                label: "T",
                onPressed: () => handleTossCall("TAIL"),
              ),
            ],
          ),
          if (!once)
            Column(
              children: [
                SizedBox(height: 30),
                Text(
                  "TOSS: $toss",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                tossWinner != "Computer"?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.trophy, color: Colors.greenAccent, size: 25),
                            const SizedBox(width: 10),
                            Text(
                              "$tossWinner won the toss ",
                              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                            const FaIcon(FontAwesomeIcons.trophy, color: Colors.greenAccent, size: 25),
                          ],
                        ),
                      ],
                    ),
                  ):Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            "$tossWinner won the toss ",
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Choice(tossWinner: tossWinner, userName: userName),
              ],
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              currentAccountPicture: CircleAvatar(
                child: Text(userName.substring(0, 1)),
              ),
              accountName: Text(userName),
              accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? ""),
            ),
            ListTile(
              tileColor: Colors.deepPurple.shade100,
              title: const Text("Log Out"),
              onTap: () async {
                final isLoggedOut = await showDialogLogOut(context);
                if (isLoggedOut) {
                  await AuthService.firebase().logOut();
                  Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
                }
              },
              leading: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CircularButton({required this.label, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary, shape: const CircleBorder(),
        padding: const EdgeInsets.all(16), // Text color
      ),
      child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}

class Choice extends StatefulWidget {
  final String? tossWinner;
  final String userName;

  const Choice({super.key, required this.tossWinner, required this.userName});

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  late String cch;
  late String uch;
  late bool showContinue;
  late bool uBat;

  @override
  void initState() {
    super.initState();
    cch = Random().nextBool() ? "BAT" : "BOWL";
    uch = "";
    showContinue = false;
    uBat = false;
    if (widget.tossWinner == "Computer") {
      uBat = cch == "BOWL";
      showContinue = true;
    }
  }

  void handleUserChoice(String choice) {
    if (!showContinue) {
      setState(() {
        uch = choice;
        uBat = choice == "BAT";
        showContinue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.tossWinner == "Computer")
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "and chose to $cch first.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        if (widget.tossWinner == widget.userName && !showContinue)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularButton(
                  label: "BAT",
                  onPressed: () => handleUserChoice("BAT"),
                ),
                SizedBox(width: 20),
                CircularButton(
                  label: "BOWL",
                  onPressed: () => handleUserChoice("BOWL"),
                ),
              ],
            ),
          ),
        if (showContinue)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (widget.tossWinner == widget.userName)
                  Text(
                    "and chose to $uch first.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MatchPage(uBat: uBat,username: widget.userName,)),
                          (route) => false,
                    );
                  },
                  child: Text("Continue"),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

