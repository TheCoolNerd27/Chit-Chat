import 'package:flutter/material.dart';
import 'package:chitchat/service_locator.dart';
import 'package:chitchat/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chitchat/profile.dart';
import 'package:chitchat/Chats.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main(){
  setupLocator();

  runApp(MyApp());

}
/*
TODO:After Login Redirect to a Form to add Details about Me
 */
final AuthenticationService _authenticationService =
locator<AuthenticationService>();
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  var usr;
  bool render()  {
    bool res;
    usr= _authenticationService.getUSer();
    if(usr == null)
      res=true;
    else
      res=false;

    print(res);
    return res;



  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chit Chat',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        //scaffoldBackgroundColor: Colors.amber[200],

      ),
      home:render()?Login():ChatList(),
    routes: {
        '/chats':(context)=>ChatList(),
        '/login':(context)=>Login(),
    },
    //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _success;
  FirebaseUser usern;
  SharedPreferences prefs;
  String _userID;
  void googleSignIn()
  async{
    prefs=await SharedPreferences.getInstance();
    var usr;
    var res=await _authenticationService.signInWithGoogle();
    print(res);
    if(res is bool)
    {
      if(res)
      {
        usr=await _authenticationService.getUSer();

          if (usr != null) {
            setState(() {
              _success = true;
              //usern = usr;
              _userID=usr.uid;

            });
            print('$usern');
            await prefs.setString('uid', usr.uid);
            Fluttertoast.showToast(
                msg: "Login Successful",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.greenAccent,
                textColor: Colors.black,
                fontSize: 16.0
            );
            print("Hello");

            var ref=Firestore.instance.collection("Users").document(usr.uid).get().then((doc){
              var dc=doc['About Me'];
              if(dc==null||doc==null)
                {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(usr)));
                }
              else
                {
                  Navigator.pushNamed(context, '/chats');
                }

            });

            //service=true;
          } else {
            setState(() {
              _success = false;
            });
            Fluttertoast.showToast(
                msg: "Login Failed! Try Again!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.redAccent,
                textColor: Colors.black,
                fontSize: 16.0
            );

          }

      }

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Login"),),
    body:Container(
      padding:EdgeInsets.all(25.0) ,
      child:Center(

        child:RaisedButton(
          padding: EdgeInsets.all(15.0),
          onPressed: () {

            googleSignIn();
          },

          child: Row(
            children: <Widget>[
              Image.asset('assets/images/google.png',
                  height:30.0,width:30.0),
              SizedBox( width:30.0),
              Text('Sign in with Google',style: TextStyle(
                fontSize: 15.0,
              ),),
            ],
          ),
          textColor: Colors.black,
          color: Colors.white,




        ),
      )
    ),
    );
  }
}



