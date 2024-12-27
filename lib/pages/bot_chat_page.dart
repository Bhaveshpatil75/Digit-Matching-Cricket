
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const String  key="AIzaSyAheDFh1MmBOo946L7xlPe3NzsG6KYl5a8";

class BotChat extends StatefulWidget {
  const BotChat({super.key});

  @override
  State<BotChat> createState() => _BotChatState();
}


class _BotChatState extends State<BotChat> {
  List<Message> chats=[Message(text: "Hello I am an AI assistant. how may I help you today?", receiver: "User")];
  var message=TextEditingController(text: "Hello, please explain the game to me");
  final model=GenerativeModel(model: "gemini-1.5-flash", apiKey: key);
  dynamic chat;
  late ScrollController scroll;
  @override
  void initState() {
    scroll=ScrollController();
    chat = model.startChat(history: [
      Content.text("what is this app?"),
      Content.model([TextPart("this is a Digit Matching Cricket game application")]),
      Content.text('please explain this game'),
      Content.model([
        TextPart(
            'Ok, the name of the game is Digit Matching Cricket. it is played between one player and bot player chooses a random number from 1,2 , 3,4 and 6 and bot does the same if the digit matches then the one who is batting gets out and score is recorded and then other one does the batting. who is batting is decided at the toss initially if the digit doesnt matches then score is added with the chosen number from batter and score rules are same as of cricket')
      ])
    ]);
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade200,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_outlined),),
        title: Row(
          children: [
            CircleAvatar(child: Text("B"),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Bot"),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(controller: scroll,
              children: chats.map((chat){
              return Container(
                padding: EdgeInsets.all(10),
                alignment: chat.receiver!="User"?Alignment.centerRight:Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints:  BoxConstraints(maxWidth: MediaQuery.of(context).size.width-50),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple.shade100
                    ),
                    padding: EdgeInsets.all(10),
                      child: Text(chat.text)),
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
                    setState(() {
                      chats.add(Message(text: message.text, receiver: "Bot"));
                      Timer(Duration(milliseconds: 300),
                              () => scroll.jumpTo(scroll.position.maxScrollExtent));
                    });
                    final content=Content.text(message.text);
                    message.clear();
                    final response=await chat.sendMessage(content);
                    setState(() {
                      chats.add(Message(text: response.text??"", receiver: "User"));
                      Timer(Duration(milliseconds: 300),
                              () => scroll.jumpTo(scroll.position.maxScrollExtent));
                    });

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
}

class Message{
 final String text;
 final String? receiver;
  Message({required this.text, required this.receiver});

}