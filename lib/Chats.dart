import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chitchat/service_locator.dart';
import 'package:chitchat/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:fluttertoast/fluttertoast.dart';

final AuthenticationService _authenticationService =
locator<AuthenticationService>();
class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

    Widget getProfiles()
    {
        return Container(
            child: StreamBuilder(
                stream: Firestore.instance.collection('Users').snapshots(),
                builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                            ),
                        );
                    } else {
                        return ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
                            itemCount: snapshot.data.documents.length,
                        );
                    }
                },
            ),
        );
    }
    Widget buildItem(context,DocumentSnapshot Doc)
    {
        return new ListTile(
            leading: CircleAvatar(backgroundImage:NetworkImage(Doc["Display Photo"])),
            title: new Text(Doc['Display Name']),
            subtitle: new Text(Doc['About Me']),
            onTap: (){}
        );
    }
    Future<bool> onBackPress() {
        openDialog();
        return Future.value(false);
    }

    Future<Null> openDialog() async {
        switch (await showDialog(
            context: context,
            builder: (BuildContext context) {
                return SimpleDialog(
                    contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                    children: <Widget>[
                        Container(
                            color: Colors.orange,
                            margin: EdgeInsets.all(0.0),
                            padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                            height: 100.0,
                            child: Column(
                                children: <Widget>[
                                    Container(
                                        child: Icon(
                                            Icons.exit_to_app,
                                            size: 30.0,
                                            color: Colors.white,
                                        ),
                                        margin: EdgeInsets.only(bottom: 10.0),
                                    ),
                                    Text(
                                        'Exit app',
                                        style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        'Are you sure to exit app?',
                                        style: TextStyle(color: Colors.white70, fontSize: 14.0),
                                    ),
                                ],
                            ),
                        ),
                        SimpleDialogOption(
                            onPressed: () {
                                Navigator.pop(context, 0);
                            },
                            child: Row(
                                children: <Widget>[
                                    Container(
                                        child: Icon(
                                            Icons.cancel,
                                            color: Colors.black,
                                        ),
                                        margin: EdgeInsets.only(right: 10.0),
                                    ),
                                    Text(
                                        'CANCEL',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    )
                                ],
                            ),
                        ),
                        SimpleDialogOption(
                            onPressed: () {
                                Navigator.pop(context, 1);
                            },
                            child: Row(
                                children: <Widget>[
                                    Container(
                                        child: Icon(
                                            Icons.check_circle,
                                            color: Colors.black,
                                        ),
                                        margin: EdgeInsets.only(right: 10.0),
                                    ),
                                    Text(
                                        'YES',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    )
                                ],
                            ),
                        ),
                    ],
                );
            })) {
            case 0:
                break;
            case 1:
                exit(0);
                break;
        }
    }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPress,

      child: Scaffold(

          appBar: AppBar(

          title: Center(child: Text("Chats")),
          actions: <Widget>[
            PopupMenuButton(
                itemBuilder:(BuildContext Context){
                    var list = List<PopupMenuEntry<Object>>();
                    list.add(
                        PopupMenuItem(
                            child: ListTile(
                                leading: Icon(Icons.settings),
                                title: Text("Settings"),
                            ),
                            value: 1,
                        ),
                    );
                    list.add(
                        PopupMenuItem(

                            child: ListTile(
                                leading: Icon(Icons.exit_to_app),
                                title: Text("Log out"),
                                onTap: (){
                                  _authenticationService.signOut();
                                  Navigator.pushNamed(context, '/login');
                                },
                            ),
                            value: 2,
                        ),
                    );
                return list;
                })
          ],
          ),
        body:getProfiles(),

      ),
    );
  }
}
