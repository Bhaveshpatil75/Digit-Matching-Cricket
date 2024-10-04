
import 'dart:async';
import 'package:fcc/services/auth/database_service.dart';
import 'package:fcc/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'bot_chat_page.dart';

class ChatPage extends StatefulWidget {
  final String chatID;
  final String receiver;
  final String rName;
   ChatPage({super.key, required this.chatID,required this.receiver,required this.rName});
   @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
    var message=TextEditingController();
    late ScrollController scroll;
    final db=DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    @override
  void initState() {
    scroll=ScrollController();
    super.initState();
  }
    @override
    Widget build(BuildContext context) {
      return StreamBuilder<List<Message>>(
        stream: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).chats(widget.chatID),
        builder: (context, snapshot) {
          final data=snapshot.data?.toList() ;
          return  Scaffold(
              appBar: AppBar(
              backgroundColor: Colors.deepPurple.shade200,
              leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_outlined),),
          title: Row(
          children: [
          CircleAvatar(child: Text(widget.rName.substring(0,1)),),
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.rName),
          ),
          ],
          ),
          ),
          body: data==null? Loading():Column(
          children: [
          Expanded(
          child: ListView(controller: scroll,
          children: data.map((item){
          return Container(
          padding: EdgeInsets.all(10),
          alignment: item.receiver==widget.receiver?Alignment.centerRight:Alignment.centerLeft,
          child: ConstrainedBox(
          constraints:  BoxConstraints(maxWidth: MediaQuery.of(context).size.width-50),
          child: Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurple.shade100
          ),
          padding: EdgeInsets.all(10),
          child: Text(item.text)),
          ),
          );

          }).toList(),)
          ),
          Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
          onTap: () async{
          Timer(Duration(milliseconds: 500), () => scroll.jumpTo(scroll.position.maxScrollExtent));
          },
          decoration: InputDecoration(
          hintText: "Message",
          border: OutlineInputBorder(),
          suffixIcon: IconButton(onPressed: () async{
              await db.update_chats(widget.chatID, widget.receiver,message.text ,DateTime.now());
          setState(() {
          //chats.add(Message(text: message.text,receiver: ));
          Timer(Duration(milliseconds: 300),
          () => scroll.jumpTo(scroll.position.maxScrollExtent));
          });
          message.clear();
          }, icon: Icon(Icons.arrow_forward),)
          ),
          controller: message,
          ),
          ),
          ),
          ],
          ),
          );
        }
      );
    }
  }
