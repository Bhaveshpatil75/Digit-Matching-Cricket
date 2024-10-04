
import 'package:fcc/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth/database_service.dart';
import 'bot_chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  final DatabaseService db=DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    build(BuildContext context) {
    return Scaffold(
        floatingActionButton: IconButton(onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>BotChat()));
        }, icon: Icon(Icons.ac_unit),
        color: Colors.deepPurple.shade300,
          iconSize: 50,
        ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade200,
        title: Text("Chats"),
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_outlined),),
        actions: [
          IconButton(onPressed: (){
          }, icon: Icon(Icons.add_circle_outline_rounded))
        ],
      ),
      body:StreamBuilder(
        stream: db.users,
        builder: (context, snapshot) {
          final data=snapshot.data?.toList() ??[];
          return data==null?Text("Nothing here"): ListView.separated(itemBuilder: (context,index){
            return ListTile(
              leading: CircleAvatar(child: FittedBox(child: Icon(Icons.account_circle_sharp,size: 50)),),
              tileColor: Colors.deepPurple.shade100,
              title: Text("${data[index].name}"),
              onTap: () {
                List a=[FirebaseAuth.instance.currentUser!.uid,data[index].Uid];
                a.sort();
                final chatID=a.join("&");
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(chatID: chatID, receiver: data[index].Uid,rName: data[index].name,)));
              },
            );
          }, separatorBuilder: (BuildContext context, int index){
            return Divider(height: 4,);
          }, itemCount: data.length,
          );
        }
      )
    );
  }
}
