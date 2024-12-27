
import 'package:fcc/dialogs/show_error_dialog.dart';
import 'package:fcc/pages/Toss_page.dart';
import 'package:fcc/pages/chat_list_page.dart';
import 'package:fcc/pages/global_rank.dart';
import 'package:fcc/pages/records.dart';
import 'package:fcc/services/open_url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../enums/menu_actions.dart';

PreferredSizeWidget? appBar(BuildContext context,String? title){
  return AppBar(
    title: Text(title??"DMC"),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    actions: [
      IconButton(onPressed: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatListPage()));
      }, icon: const Icon(Icons.chat)),
      PopupMenuButton<MenuAction>(itemBuilder: (value){
        return [
          const PopupMenuItem(child: Text("New Game"),value: MenuAction.newGame,),
          const PopupMenuItem(child: Text("Previous Matches"),value: MenuAction.records,),
          const PopupMenuItem(child: Text("Global Rankings"),value: MenuAction.globalRank,),
         // const PopupMenuItem(child: Text("Feedback"),value: MenuAction.feedback,),
        ];
      },
        onSelected: (value)async{
        switch(value){
          case MenuAction.newGame:
            SharedPreferences prefs=await SharedPreferences.getInstance();
            String name=prefs.getString("name")??"User";
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>TossPage(username: name)), (_)=>false);
            //Navigator.pushNamedAndRemoveUntil(context, tossRoute, (_)=>false);
          case MenuAction.records:
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Records()));
          case MenuAction.feedback:
            try{
             await openUrl("https://flutter.dev");
            }catch(e){
              await showErrorDialog(context, "Error in opening URL");
            }
          case MenuAction.globalRank:
            Navigator.push(context, MaterialPageRoute(builder: (context)=>GlobalRank()));
        }
        },
      )
    ],
  );
}