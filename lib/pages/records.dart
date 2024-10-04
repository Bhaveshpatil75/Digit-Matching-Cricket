
import 'package:fcc/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:fcc/pages/appBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fcc/services/auth/database_service.dart';
class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: Center(
          child: recordsList(),
        ),
      );
  }
}

class recordsList extends StatefulWidget {
  const recordsList({super.key});

  @override
  State<recordsList> createState() => _recordsListState();
}

class _recordsListState extends State<recordsList> {
  late String user;
  @override
  void initState() {
    user=FirebaseAuth.instance.currentUser?.displayName??"User";
    super.initState();
  }

  final DatabaseService db=DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    final DateFormat format=DateFormat("dd/MM/yyyy").add_jm();
    return StreamBuilder(stream: db.data, builder: (context,snapshot){
      switch(ConnectionState){
        case ConnectionState.none:
          return Center(child: Text("Unable to fetch data"));
        case ConnectionState.waiting:
          return Loading();
        default:
          final data=snapshot.data?.reversed.toList()??[];
          print(data);
          return data==[]?Center(child: Text("Nothing to show...")):ListView.separated(
            itemBuilder:(context,index){
              return ListTile(
                leading: CircleAvatar(child: Center(child: Text((index+1).toString()))),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text("$user Score:${data[index].uScore}"),
                          Text("Computer Score:${data[index].cScore}")
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(format.format(data[index].dt.toDate())))
                  ],
                ),
                title: Text(data[index].winner),
                // trailing: Text(format.format(data[index].dt.toDate())),
              );
            },
            itemCount: data.length,
            padding: EdgeInsets.all(5),
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 3,
              );
            },
          );
      }
    }
    );
  }
}

