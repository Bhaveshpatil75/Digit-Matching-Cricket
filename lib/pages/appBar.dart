
import 'package:fcc/dialogs/show_error_dialog.dart';
import 'package:fcc/pages/chat_list_page.dart';
import 'package:fcc/pages/global_rank.dart';
import 'package:fcc/pages/records.dart';
import 'package:fcc/services/open_url.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../enums/menu_actions.dart';

PreferredSizeWidget? appBar(BuildContext context){
  return AppBar(
    title: Text("Cricket"),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    actions: [
      IconButton(onPressed: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatListPage()));
      }, icon: Icon(Icons.chat)),
      PopupMenuButton<MenuAction>(itemBuilder: (value){
        return [
          PopupMenuItem(child: Text("New Game"),value: MenuAction.newGame,),
          PopupMenuItem(child: Text("Previous Matches"),value: MenuAction.records,),
          PopupMenuItem(child: Text("Global Rankings"),value: MenuAction.globalRank,),
          PopupMenuItem(child: Text("Feedback"),value: MenuAction.feedback,),
        ];
      },
        onSelected: (value)async{
        switch(value){
          case MenuAction.newGame:
            Navigator.pushNamedAndRemoveUntil(context, tossRoute, (_)=>false);
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