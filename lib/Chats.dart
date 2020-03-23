import 'package:flutter/material.dart';
import 'package:chitchat/service_locator.dart';
import 'package:chitchat/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    Widget getProfiles()
    {
        return Container(
            child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
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
            title: new Text(Doc['Name']),
            subtitle: new Text(Doc['About me']),
            onTap: (){}
        );
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Chats"),),
      body:getProfiles(),
    );
  }
}
