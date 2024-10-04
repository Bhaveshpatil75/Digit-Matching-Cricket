import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcc/pages/bot_chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Match{
  int uScore,cScore;
  String winner;
  dynamic dt;
  Match({required this.uScore,required this.cScore,required this.winner,required this.dt});
}

class Global{
  int highScore;
  String name,player;
  dynamic dt;
  Global({required this.player,required this.name,required this.highScore,required this.dt});
}

class Player{
  String Uid;
  String name;
  Player({required this.Uid,required this.name});
}

class DatabaseService{
   String uid;
   DatabaseService({required this.uid});

  final matchDb=FirebaseFirestore.instance.collection("UserData").doc(FirebaseAuth.instance.currentUser!.uid).collection("Matches");
  final globalDb=FirebaseFirestore.instance.collection("GlobalDB");
  final chatDb=FirebaseFirestore.instance.collection("ChatRooms");

  List<Match> fromsnapshot(QuerySnapshot snap){
    return snap.docs.map((doc) {
      return Match(uScore: doc.get("uScore"), cScore: doc.get("cScore"), winner: doc.get("winner"), dt: doc.get("dateTime"));
    }).toList();
  }
  
  List<Global> fromSnapshot(QuerySnapshot snap){
    return snap.docs.map((doc){
      return Global(name: doc.get("name"), highScore: doc.get("highScore"), dt: doc.get("dateTime"), player: doc.get("player"));
    }).toList();
  }
  List<Player> from(QuerySnapshot snap){
    return snap.docs.map((doc){
      return Player(Uid: doc.id, name: doc.get("name"));
    }).toList();
  }

  Stream<List<Match>> get data{
    return matchDb.snapshots().map(fromsnapshot);
  }


  Stream <List<Player>> get users{
    return FirebaseFirestore.instance.collection("UserData").snapshots().map(from);
  }

  Stream<List<Global>> get globalData{
    return globalDb.snapshots().map(fromSnapshot);
  }

  Future<void> addUser(String name)async{
    await FirebaseFirestore.instance.collection("UserData").doc(uid).set({
      "name":name
    });
  }

  Future<void> update(int uScore,int cScore,String winner,dynamic dt)async{
      await matchDb.doc(dt.toString()).set({
        "uScore":uScore,"cScore":cScore,"winner":winner,"dateTime":dt
      });
  }
  List<Message> retrieve(QuerySnapshot snap){
    return snap.docs.map((doc){
      return Message(text: doc.get("chat"), receiver: doc.get("receiver"));
    }).toList();
  }

  Stream<List<Message>> chats(String chatID){
    return chatDb.doc(chatID).collection("messages").orderBy("time").snapshots().map(retrieve);
  }

  Future<void> update_global(String player,int highScore,String name,dynamic dt)async{
    await globalDb.doc("highscore").set({
      "player":player,"highScore":highScore,"name":name,"dateTime":dt
    });
  }
  Future<void> update_chats(String chatID,String rUid,String chat,dynamic dt)async{
    await chatDb.doc(chatID).collection("messages").add({
      "chat":chat,"time":dt,"receiver":rUid
    });
  }
}