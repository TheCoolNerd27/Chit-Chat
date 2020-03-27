import 'package:flutter/material.dart';
import 'package:chitchat/service_locator.dart';
import 'package:chitchat/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  String peerId;
  DocumentSnapshot peer;
  ChatScreen(this.peerId, this.peer);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SharedPreferences prefs;
  String chatId, userId;
  var listMessage;
  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();



  void getUID() async {
      prefs = await SharedPreferences.getInstance();
      setState(() {
          userId = prefs.get('uid');
      });
      if (widget.peerId.compareTo(userId) == -1) {
          setState(() {
              chatId = widget.peerId + userId;
          });
      } else if (userId.compareTo(widget.peerId) == -1) {
          setState(() {
              chatId = userId + widget.peerId;
          });
      }
  }
  Widget buildItem(BuildContext Context,DocumentSnapshot Doc)
  {    if(Doc['idFrom']==widget.peerId)
      return Container(

        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             Row(
                 children: <Widget>[
                     CircleAvatar(
                         backgroundImage: NetworkImage(widget.peer["Display Photo"]),radius: 15.0,),

                     Container(
                         child: Text(
                             Doc['content'],
                         ),
                         padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                         width: 200.0,
                         decoration: BoxDecoration(color: Colors.amber[600], borderRadius: BorderRadius.circular(8.0)),

                         margin: EdgeInsets.only(left: 10.0,top:15,bottom:10.0),
                     ),



                 ],
             ),
                Container(
                    child: Text(
                        DateFormat('dd MMM kk:mm')
                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(Doc['timestamp']))),
                        style: TextStyle(color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                )
            ],

        ),
      );
  else
      {
          return Container(

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                    Container(
                        child: Text(
                            Doc['content'],
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(color: Colors.amber[600], borderRadius: BorderRadius.circular(8.0)),

                        margin:EdgeInsets.only(bottom:15.0, right: 10.0),
                    ),
                    Container(
                        child: Text(
                            DateFormat('dd MMM kk:mm')
                                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(Doc['timestamp']))),
                            style: TextStyle(color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                        ),
                        margin: EdgeInsets.only(right: 10.0, top: 5.0, bottom: 15.0),
                    )

                ],
            ),
          );
      }

  }

  Widget buildMessage() {
      getUID();
    return Container(
      child: chatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('Chats')
                  .document(chatId)
                  .collection("Messages")
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
  void onMessageSent(String content,int type) {
      if (content.trim() != '') {
          var ref = Firestore.instance.collection('Chats')
              .document(chatId)
              .collection('Messages')
              .add({

              "content": content,
              "timestamp": DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString(),
              "idFrom": userId,
              "type":type
          });
          listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
      else
          {
              Fluttertoast.showToast(msg: 'Nothing to send');
          }
  }
  Widget buildInput() {
      return Container(
          child: Row(
              children: <Widget>[
                  // Button send image
                  Material(
                      child: new Container(
                          margin: new EdgeInsets.symmetric(horizontal: 1.0),
                          child: new IconButton(
                              icon: new Icon(Icons.image),
                              onPressed:(){} ,//getImage,
                              color: Colors.orange,
                          ),
                      ),
                      color: Colors.white,
                  ),
                  Material(
                      child: new Container(
                          margin: new EdgeInsets.symmetric(horizontal: 1.0),
                          child: new IconButton(
                              icon: new Icon(Icons.face),
                              onPressed:(){} ,//getSticker,
                              color: Colors.orange,
                          ),
                      ),
                      color: Colors.white,
                  ),

                  // Edit text
                  Flexible(
                      child: Container(
                          child: TextField(
                              style: TextStyle(color: Colors.orange, fontSize: 15.0),
                              controller: textEditingController,
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Type your message...',
                                  hintStyle: TextStyle(color: Colors.grey),
                              ),
                              //focusNode:focusNode,
                          ),
                      ),
                  ),

                  // Button send message
                  Material(
                      child: new Container(
                          margin: new EdgeInsets.symmetric(horizontal: 8.0),
                          child: new IconButton(
                              icon: new Icon(Icons.send),
                              onPressed:()=> onMessageSent(textEditingController.text, 0),
                              color: Colors.orange,
                          ),
                      ),
                      color: Colors.white,
                  ),
              ],
          ),
          width: double.infinity,
          height: 50.0,
          decoration: new BoxDecoration(
              border: new Border(top: new BorderSide(color: Color(0xffE8E8E8), width: 0.5)), color: Colors.white),
      );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Icon(Icons.arrow_back),
        title: ListTile(
            leading:CircleAvatar(
                backgroundImage: NetworkImage(widget.peer["Display Photo"]),radius: 20.0,) ,
            title: Text(widget.peer['Display Name'],style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.0
            ),),),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
              buildMessage(),
//                SizedBox(
//                    height: 30.0,
//                ),
              Align(

                alignment: FractionalOffset.bottomCenter,
                child: buildInput(),
              )
          ],
        ),
      ),
    );
  }
}
