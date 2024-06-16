import 'package:fcc/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../dialogs/show_logout_dialog.dart';
import '../enums/menu_actions.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}



class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Content"),
        actions: [
          PopupMenuButton<MenuAction>(itemBuilder: (value){
            return [PopupMenuItem(child: Text("Log out"),value: MenuAction.logout,)];
          },
            onSelected: (value)async{
              final loggedOut= await showDialogLogOut(context);
              if (loggedOut){
                await AuthService.firebase().logOut();
                Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route)=>false);
              }
            },
          )
        ],
      ),
      body: Container(
        child:Center(
            child:Text("blah blah blah...")
        ),
      ),
    );
  }
}