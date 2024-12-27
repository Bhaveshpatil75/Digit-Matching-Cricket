import 'package:fcc/pages/appBar.dart';
import 'package:fcc/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth/database_service.dart';

class GlobalRank extends StatelessWidget {
  const GlobalRank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,"Global Rankings"),
      body: Ranks(),
    );
  }
}

class Ranks extends StatelessWidget {
  const Ranks({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    final DateFormat format = DateFormat("dd/MM/yyyy").add_jm();
    return StreamBuilder<List<Global>>(
      stream: db.globalData,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Loading();
          case ConnectionState.none:
            return Center(child: Text("Unable to fetch data"));
          default:
            final data = snapshot.data?.toList();
            return data == null
                ? Center(child: Text("Nothing to show here"))
                : SizedBox(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PlayerInfoTile(
                      icon: FontAwesomeIcons.user,
                      label: 'Player',
                      value: data[0].player,
                    ),
                    PlayerInfoTile(
                      icon: FontAwesomeIcons.solidStar,
                      label: 'High Score',
                      value: data[0].highScore.toString(),
                    ),
                    PlayerInfoTile(
                      icon: FontAwesomeIcons.trophy,
                      label: 'High Scorer',
                      value: data[0].name,
                    ),
                    PlayerInfoTile(
                      icon: FontAwesomeIcons.calendarDay,
                      label: 'Played on',
                      value: format.format(data[0].dt.toDate()),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}

class PlayerInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const PlayerInfoTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, color: Theme.of(context).colorScheme.primary, size: 30),
          SizedBox(width: 10),
          Text(
            '$label : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
