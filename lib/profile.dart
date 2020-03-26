import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/service_locator.dart';
import 'package:chitchat/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Profile extends StatefulWidget {
  FirebaseUser user;
  Profile(this.user);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String nickname, aboutme;
  TextEditingController controllerNickname;
  TextEditingController controllerAboutMe;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      nickname = widget.user.displayName;
    });

    controllerNickname = new TextEditingController(text: nickname);
    controllerAboutMe = new TextEditingController();
  }

  void submitData() async{

    var ref = Firestore.instance
        .collection("Users")
        .document(widget.user.uid)
        .updateData({"Display Name": nickname, "About Me": aboutme}).then(
            (value) async {



      Fluttertoast.showToast(
          msg: "Update Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black,
          fontSize: 16.0);
      Navigator.pushNamed(context, '/chats');
    }).catchError((err) {
      Fluttertoast.showToast(
          msg: err.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.redAccent,
          textColor: Colors.black,
          fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,


            //padding:EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                  child: Center(
                child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.photoUrl),
                  radius:40.0 ,
                ),
              ),),
              TextField(
                controller: controllerNickname,
                decoration: InputDecoration(labelText: 'Display Name'),
                onSubmitted: (value) {
                  setState(() {
                    nickname = value;
                  });
                },
              ),
              TextField(
                controller: controllerAboutMe,
                decoration: InputDecoration(
                  labelText: 'About me',
                ),
                onSubmitted: (value) {
                  setState(() {
                    aboutme = value;
                  });
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                  onPressed: () => submitData(),
                  child: Text("Submit"),
                  textColor: Colors.black,
                  color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }
}
