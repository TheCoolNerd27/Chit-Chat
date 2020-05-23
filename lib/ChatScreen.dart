import 'package:flutter/material.dart';
import 'package:chitchat/service_locator.dart';
import 'package:chitchat/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:chitchat/Encryption.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import './src/pages/call.dart';
Crypto _crypto=new Crypto();
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
  File _image;
  var privateKey,publicKey;
  var listMessage;
  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  final _channelController = TextEditingController();



  @override
  void dispose() {
      // dispose input controller
      _channelController.dispose();
      super.dispose();
  }

  void getUID() async {
      print("MMM");
     prefs = await SharedPreferences.getInstance();

      setState(() {
          userId = prefs.get('uid');
          privateKey=prefs.getString('private');
      });
      //print(privateKey.substring(privateKey.length - 50));
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
  Widget buildItem(BuildContext Context,DocumentSnapshot Doc) {
      //TODO:Decrypt Message here!!


      //print('KKKKKK$decrypted');
      if (Doc['idFrom'] == widget.peerId) {
          if (Doc['type'] == 0){
              String content = Doc['content'];
//              String encrypted = Doc['content'];
//              Uint8List data = convertString(encrypted);
//              var pvt = _crypto.parsePrivateKeyFromPem(privateKey);
//              Uint8List bytes = _crypto.rsaDecrypt(pvt, data);
//              String decrypted = convertUint8List(bytes);
              return Container(

                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Row(
                              children: <Widget>[
                                  CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          widget.peer["Display Photo"]),
                                      radius: 15.0,),

                                  Container(
                                      child: Text(
                                          "$content",
                                      ),
                                      padding: EdgeInsets.fromLTRB(
                                          15.0, 10.0, 15.0, 10.0),
                                      width: 200.0,
                                      decoration: BoxDecoration(
                                          color: Colors.amber[600],
                                          borderRadius: BorderRadius.circular(
                                              8.0)),

                                      margin: EdgeInsets.only(
                                          left: 10.0, top: 15),
                                  ),


                              ],
                          ),
                          Container(
                              child: Text(
                                  DateFormat('dd MMM kk:mm')
                                      .format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(Doc['timestamp']))),
                                  style: TextStyle(color: Colors.grey,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic),
                              ),
                              margin: EdgeInsets.only(
                                  left: 10.0, top: 5.0, bottom: 25.0),
                          )
                      ],

                  ),
              );
      }
         else if(Doc['type']==1)
             {
                 return Container(
                     child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                        Row(
                            children: <Widget>[
                            CircleAvatar(
                            backgroundImage: NetworkImage(
                            widget.peer["Display Photo"]),
                            radius: 15.0,),

                            Container(
                                child:Image.network(Doc['content'],width:200.0) ,
                               // padding: EdgeInsets.fromLTRB(
                                 //   15.0, 10.0, 15.0, 10.0),
                                width: 200.0,

                                decoration: BoxDecoration(
                                    color: Colors.amber[600],
                                    borderRadius: BorderRadius.circular(8.0)),

                                margin: EdgeInsets.only(left: 10.0, top: 15),
                            )

                            ],),
                             Container(
                                 child: Text(
                                     DateFormat('dd MMM kk:mm')
                                         .format(DateTime.fromMillisecondsSinceEpoch(
                                         int.parse(Doc['timestamp']))),
                                     style: TextStyle(color: Colors.grey,
                                         fontSize: 12.0,
                                         fontStyle: FontStyle.italic),
                                 ),
                                 margin: EdgeInsets.only(
                                     left: 10.0, top: 5.0, bottom: 25.0),
                             )
                         ],

                     ),

                 );
             }

  }
  else {
          if (Doc['type'] == 0){
             String content= Doc['content'];
//             String encrypted = Doc['content'];
//              Uint8List data = convertString(encrypted);
//              var pvt = _crypto.parsePrivateKeyFromPem(privateKey);
//              Uint8List bytes = _crypto.rsaDecrypt(pvt, data);
//              String decrypted = convertUint8List(bytes);
              return Container(

                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                          Container(
                              child: Text(
                                  '$content',
                              ),
                              padding: EdgeInsets.fromLTRB(
                                  15.0, 10.0, 15.0, 10.0),
                              width: 200.0,
                              decoration: BoxDecoration(
                                  color: Colors.amber[600],
                                  borderRadius: BorderRadius.circular(8.0)),

                              margin: EdgeInsets.only(top: 15.0, right: 10.0),
                          ),
                          Container(
                              child: Text(
                                  DateFormat('dd MMM kk:mm')
                                      .format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(Doc['timestamp']))),
                                  style: TextStyle(color: Colors.grey,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic),
                              ),
                              margin: EdgeInsets.only(
                                  right: 10.0, top: 5.0, bottom: 25.0),
                          )

                      ],
                  ),
              );
      }
         else if(Doc['type']==1)
             {
                 return Container(
                     child: Column(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: <Widget>[
                             Container(
                                 child:Image.network(Doc['content'],width:200.0) ,
                                 //padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                 width: 200.0,

                                 decoration: BoxDecoration(color: Colors.amber[600], borderRadius: BorderRadius.circular(8.0)),

                                 margin:EdgeInsets.only(top:15.0, right: 10.0),
                             ),
                             Container(
                                 child: Text(
                                     DateFormat('dd MMM kk:mm')
                                         .format(DateTime.fromMillisecondsSinceEpoch(int.parse(Doc['timestamp']))),
                                     style: TextStyle(color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                                 ),
                                 margin: EdgeInsets.only(right: 10.0, top: 5.0, bottom: 25.0),
                             )
                         ],
                     ),
                 );

             }
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
                  //listMessage = snapshot.data.documents;
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
  Uint8List convertString(String message)
  {

      List<int> list = message.codeUnits;
      Uint8List bytes = Uint8List.fromList(list);
      return bytes;

  }
  String convertUint8List(Uint8List bytes)
  {
      String message = String.fromCharCodes(bytes);
      return message;
  }
  void onMessageSent(String content,int type) {

          //TODO:Encrypt Message Here!!
          var public, pub;
          var encrypted,encrypter;
          print("HHHHHHHH$content");
          Uint8List data = convertString(content);
          var ref2 = Firestore.instance.collection("Users")
              .document(widget.peerId).get().then((doc) {
//              pub = doc['Public Key'];
              print("JJJJ$content");
//              public = _crypto.parsePublicKeyFromPem(pub);
//              encrypter=Encrypter(RSA(publicKey:public,privateKey:privateKey));
//              encrypted=encrypter.encrypt(content);
//              Uint8List bytes = _crypto.rsaEncrypt(public, data);
//              encrypted = convertUint8List(bytes);
          }).then((value) {
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
                      "type": type
                  });
                  listScrollController.animateTo(
                      0.0, duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut);
//            textEditingController.clear();
              }
              else {
                  Fluttertoast.showToast(msg: 'Nothing to send');
              }
          });
          textEditingController.clear();

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
                              onPressed:(){
                                pick();

                              } ,//getImage,
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
  void pick() async {
      //pick image   use ImageSource.camera for accessing camera.
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
//          CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
          ));
      if(croppedFile!= null) {
          setState(() {
              _image = croppedFile;
          });
          upload();
      }


  }

  Future upload() async {
      //basename() function will give you the filename
      String fileName = path.basename(_image.path);
      var now = new DateTime.now().millisecondsSinceEpoch
          .toString();
      //passing your path with the filename to Firebase Storage Reference
      StorageReference reference =
      FirebaseStorage().ref().child("Media/$chatId/$now/$fileName");

      //upload the file to Firebase Storage
      StorageUploadTask uploadTask = reference.putFile(_image);

      //TODO: GET PROPER ID AND THEN UPLOAD
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      print('IMAGE:$downloadUrl');
      var ref=Firestore.instance.collection('Chats').document(chatId).collection('Messages');
      ref.add({"content":downloadUrl,"idFrom":userId,"timestamp":now,"type":1});
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed:()=> Navigator.pop(context, 0)),
        actions: <Widget>[
            IconButton(icon: Icon(Icons.videocam), onPressed: onJoin)

        ],
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

  Future<void> _handleCameraAndMic() async {
      await Permission.camera.request();
      await Permission.microphone.request();
  }
  Future<void> onJoin() async {
      // update input validation
      _channelController.text=chatId;
      if (_channelController.text.isNotEmpty) {
          // await for camera and mic permissions before pushing video page
          await _handleCameraAndMic();
          // push video page with given channel name
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CallPage(
                      channelName: _channelController.text,
                  ),
              ),
          );
      }


  }



}
