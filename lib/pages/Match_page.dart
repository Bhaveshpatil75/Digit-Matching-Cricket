import 'dart:math';
import 'package:fcc/pages/appBar.dart';
import 'package:fcc/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth/database_service.dart';
import 'Toss_page.dart';

class MatchPage extends StatefulWidget {
  late bool uBat;
  String username="User";
  MatchPage({super.key, required this.uBat,required this.username});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  late int uScore, cScore, uCall, cCall, hs;
  late bool uChaser;
  String? matchWinner;
  late String user, winMsg;
  late bool secondInning;
  late bool uBat1, loading, done;
  late List<bool> onceGlory;
  final DatabaseService db = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);

  @override
  void initState() {
    super.initState();
    uScore = cScore = uCall = cCall = hs = 0;
    uChaser = widget.uBat ? false : true;
    //user = FirebaseAuth.instance.currentUser?.displayName ?? "User";
    user=widget.username;
    if (user.isEmpty) {
      user = "User";
    }
    secondInning = loading = done = false;
    winMsg = "";
    uBat1 = widget.uBat;
    onceGlory = [true];
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      appBar: appBar(context,null),
      body: StreamBuilder<List<Global>>(
          stream: db.globalData,
          builder: (context, snapshot) {
            final data = snapshot.data?.toList();
            data != null ? hs = data[0].highScore : 0;
            print(hs);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    margin: EdgeInsets.all(30),
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(
                                user,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(uBat1 ? "Batting" : "Bowling"),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$uScore",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                              ),
                              Text('$uCall'),
                              Text("Your call")
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(
                                'Computer',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(uBat1 ? "Bowling" : "Batting"),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$cScore",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                              ),
                              Text("$cCall"),
                              Text("Computer call")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    spacing: 10,
                    children: [
                      Wrap(
                        spacing: 10,
                        children: [
                          ElevatedButton(
                            onPressed: !done ? () => handleButtonClick(1) : null,
                            child: Text("1"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.blue,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(24),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: !done ? () => handleButtonClick(2) : null,
                            child: Text("2"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(24),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: !done ? () => handleButtonClick(3) : null,
                            child: Text("3"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.orange,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(24),
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 20,
                        children: [
                          ElevatedButton(
                            onPressed: !done ? () => handleButtonClick(4) : null,
                            child: Text("4"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.purple,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(24),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: !done ? () => handleButtonClick(6) : null,
                            child: Text("6"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.red,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    done ? winMsg : "",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (done)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => TossPage(username: user,)),
                              (route) => false,
                        );
                      },
                      child: Text("Play Again"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            );
          }),
    );
  }

  int Randi() {
    var lis = [1, 2, 3, 4, 6];
    int ind = Random().nextInt(5);
    return lis[ind];
  }

  void handleButtonClick(int u) {
    int c = Randi();
    setState(() {
      uCall = u;
      cCall = c;
    });
    update(u, user);
  }

  void update(int u, String user) async {
    int c = Randi();
    setState(() {
      uCall = u;
      cCall = c;
    });

    if (widget.uBat) {
      if (u == c) {
        await showScorecard(context, "OUT!!!", secondInning ? "$user is out on $uScore" : "$user is out on $uScore. Target for Computer is ${uScore + 1}");
        if (secondInning && uScore == cScore) {
          matchWinner = "tie";
          winMsg = "Match Tied";
        } else {
          if (!secondInning) {
            setState(() {
              uBat1 = false;
            });
          }
          setState(() {
            widget.uBat = false;
            secondInning = true;
          });
          if (uScore < cScore) {
            matchWinner = "Computer";
            winMsg = "Computer won by ${cScore - uScore} Runs";
          }
        }
      } else {
        setState(() {
          uScore += u;
        });
        checkGlory(uScore, user);
      }
    } else {
      if (u == c) {
        await showScorecard(context, "OUT!!!", secondInning ? "Computer is out on $cScore" : "Computer is out on $cScore. Target for $user is ${cScore + 1}");
        if (secondInning && uScore == cScore) {
          matchWinner = "tie";
          winMsg = "Match Tied";
        } else {
          if (!secondInning) {
            setState(() {
              uBat1 = true;
            });
          }
          setState(() {
            widget.uBat = true;
            secondInning = true;
          });
          if (uScore > cScore) {
            matchWinner = user;
            winMsg = "$user won by ${uScore - cScore} Runs";
          }
        }
      } else {
        setState(() {
          cScore += c;
        });
        checkGlory(cScore, "Computer");
      }
    }
    await Check(user);
  }

  Future<void> Check(String user) async {
    if (uChaser) {
      if (uScore > cScore) {
        winMsg = "$user won while chasing";
        matchWinner = user;
      }
    } else {
      if (cScore > uScore) {
        matchWinner = "Computer";
        winMsg = "Computer won while chasing";
      }
    }
    if (matchWinner != null) {
      setState(() {
        done = true;
      });
      await showScorecard(context, "Match Completed!!!", winMsg);
      await handleDatabaseUpdate(user);
    }
  }

  Future<void> handleDatabaseUpdate(String user) async {
    try {
      setState(() {
        loading = true;
      });
      if (hs < max(uScore, cScore)) {
        await db.update_global(user, max(uScore, cScore), matchWinner ?? "", DateTime.now());
      }
      await db.update(uScore, cScore, winMsg, DateTime.now());
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void checkGlory(int score, String name) async {
    int ind = (score / 50).floor();
    if (onceGlory[0]) {
      if (score >= 50) await showScorecard(context, "Fifty!!!", "Fifty for $name");
      setState(() {
        onceGlory[0] = false;
      });
      onceGlory.add(true);
    } else if (onceGlory[1]) {
      if (score >= 100) await showScorecard(context, "Century!!!", "Century for $name");
      setState(() {
        onceGlory[1] = false;
      });
      onceGlory.add(true);
    } else if (onceGlory[ind - 1]) {
      await showScorecard(context, "${50 * ind}", "${50 * ind} for $name");
      setState(() {
        onceGlory[ind - 1] = false;
      });
      onceGlory.add(true);
    }
  }
}

Future<void> showScorecard(BuildContext context, String title, String content) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Continue"),
          ),
        ],
      );
    },
  );
}
