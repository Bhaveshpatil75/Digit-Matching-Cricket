import 'package:fcc/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:fcc/pages/appBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fcc/services/auth/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,"Previous Matches"),
      body: Center(
        child: RecordsList(),
      ),
    );
  }
}

class RecordsList extends StatefulWidget {
  const RecordsList({super.key});

  @override
  State<RecordsList> createState() => _RecordsListState();
}

class _RecordsListState extends State<RecordsList> {
   String user="User";

  @override
  void initState() {
    //user = FirebaseAuth.instance.currentUser?.displayName ?? "User";
    super.initState();
  }

  final DatabaseService db = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat("dd/MM/yyyy").add_jm();
    return StreamBuilder(
      stream: db.data,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: Text("Unable to fetch data"));
          case ConnectionState.waiting:
            return Loading();
          default:
            final data = snapshot.data?.reversed.toList() ?? [];
            print(data);
            return data.isEmpty
                ? Center(child: Text("Nothing to show..."))
                : ListView.separated(
              itemBuilder: (context, index) {
                return AnimatedListTile(
                  index: index,
                  user: user,
                  data: data,
                  format: format,
                );
              },
              itemCount: data.length,
              padding: EdgeInsets.all(5),
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 2,
                  color: Colors.grey[400],
                );
              },
            );
        }
      },
    );
  }
}

class AnimatedListTile extends StatelessWidget {
  final int index;
  final String user;
  final List data;
  final DateFormat format;

  const AnimatedListTile({
    Key? key,
    required this.index,
    required this.user,
    required this.data,
    required this.format,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          // leading: CircleAvatar(
          //   child: Center(child: FaIcon(Icons.sports_cricket, size: 20)),
          //   backgroundColor: Colors.blue[50],
          //   foregroundColor: Colors.black,
          // ),
          title: Text(
            data[index].winner,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          subtitle: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$user Score: ${data[index].uScore}",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "Computer Score: ${data[index].cScore}",
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  format.format(data[index].dt.toDate()),
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          trailing: data[index].cScore<data[index].uScore?const FaIcon(FontAwesomeIcons.trophy, color: Colors.amber):null,
        ),
      ),
    );
  }
}
