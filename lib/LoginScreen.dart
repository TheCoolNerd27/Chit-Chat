import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help4real/service_locator.dart';
import 'package:help4real/auth_service.dart';

/*

TODO:Remove Post tab from Drawer
 */

final AuthenticationService _authenticationService =
locator<AuthenticationService>();
//final FirebaseAuth _auth = FirebaseAuth.instance;
//final GoogleSignIn _googleSignIn = GoogleSignIn();
bool service;

class MyLoginPage extends StatelessWidget {
  var title = 'My Login Page!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
    ),
    ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Image.asset('assets/images/Logo.png',height: MediaQuery.of(context).size.height*0.25),
              LoginForm(),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  bool _success,isHelp=true;
  FirebaseUser usern;

  String _userID;
 String username,password;
  var pass=GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: <Widget>[
          SizedBox(
              width: MediaQuery.of(context).size.width,
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Email',icon:Icon(Icons.email),
              ),
              validator: (value) {
                var pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);

                if (!regex.hasMatch(value)) {
                  return 'Please enter a Valid Email!';
                }
                setState(() {
                  username = value;
                });

                return null;
              },
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
            child: TextFormField(
              key: pass,
              decoration: InputDecoration(labelText: 'Password:',icon:Icon(Icons.vpn_key)),
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password cannot be empty!';
                }
                else if(value.length<8)
                  return 'Password should be atleast 8 characters long!';

                setState(() {
                  password = value;
                });

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0,horizontal:25.0),
           child: ButtonTheme(
             minWidth:MediaQuery.of(context).size.width,
             height: 40.0,

             child: Column(
               children: <Widget>[
                 RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formkey.currentState.validate()) {
                        // If the form is valid, check credentials then redirect
                        print('Username:$username Password:$password');
                        signInWithEP();
                        _formkey.currentState.reset();

                      }
                    },
                    child: Text('Login'),
                   textColor: Colors.white,
                    color: Colors.blue,




                  ),
                 SizedBox( height:15.0,
                     width: MediaQuery.of(context).size.width,),
                 RaisedButton(
                   
                   onPressed: () {

                       googleSignIn();
                   },

                   child: Row(
                     children: <Widget>[
                       Image.asset('assets/images/google.png',
                       height:30.0,width:30.0),
                       SizedBox( width:30.0),
                       Text('Sign in with Google'),
                     ],
                   ),
                   textColor: Colors.black,
                   color: Colors.white,




                 ),

               ],
             ),
           ),
          ),
        ],
      ),
    );
  }
/*  void _signInWithGoogle() async {


      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult authResult = await _auth.signInWithCredential(credential);

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      if (authResult.additionalUserInfo.isNewUser) {
          var ref=Firestore.instance.collection('Helpers').document(user.uid);
          ref.setData({"email":user.email,"Name":user.displayName});
      }
      else {
          print('Welcome');
      }
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      setState(() {
        if (user != null) {
            setState(() {
                _success = true;
                usern = user;
                _userID=user.uid;

            });
            print('$user');
            service=true;
        } else {
            setState(() {
                _success = false;
            });

        }
      });





  }



  Future<void> _signInWithEmailAndPassword() async {
      FirebaseUser user;
      try {
           user = (await _auth.signInWithEmailAndPassword(
              email: username,
              password: password,
          ))
              .user;
      }
      catch(e)
      {
          return showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text('Invalid Username or Password!'),
                      content: Text('Common Try Harder!'),
                      actions: <Widget>[
                  FlatButton(
                  child: Text('Okay!'),
                  onPressed: () {
                  Navigator.of(context).pop();
                  })
                      ],
                  );
              }
          );

      }
    if (user != null) {
      setState(() {
        _success = true;
        _userID = user.uid;
        usern=user;

      });
      service=false;
    } else {
      _success = false;
    }
  }*/

void signInWithEP()
async{
    var res=await _authenticationService.loginWithEmail(email: username, password: password);
    if(res is bool)
        {
            if(!res)
                {
                    return showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text('Sign In Failed'),
                                content: Text('Incorrect Username or Password!!'),
                                actions: <Widget>[
                                    FlatButton(
                                        child: Text('Okay!'),
                                        onPressed: () {
                                            Navigator.of(context).pop();
                                        })
                                ],
                            );
                        }
                    );


                }
        }
    else
        return showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Sign In Failure'),
                    content: Text('$res'),
                    actions: <Widget>[
                        FlatButton(
                            child: Text('Okay!'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            })
                    ],
                );
            }
        );


}

void googleSignIn()
async{
    var usr;
    var res=await _authenticationService.signInWithGoogle();
    if(res is bool)
        {
            if(res)
                {
                  usr=_authenticationService.getUSer();
                 setState(() {
                     if (usr != null) {
                         setState(() {
                             _success = true;
                             usern = usr;
                             _userID=usr.uid;

                         });
                         print('$usern');
                         service=true;
                     } else {
                         setState(() {
                             _success = false;
                         });

                     }
                 });
                }

        }

}



}
class MyDrawer extends StatefulWidget {
    Future<FirebaseUser> getUser()async{
        FirebaseUser udf=await _authenticationService.getUSer();
        return udf;

    }
    
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
    MyDrawer obj=new MyDrawer();
    FirebaseUser user;
    String name;
    @override
    void initState() {
    // TODO: implement initState
    super.initState();



    auth.onAuthStateChanged.listen((us)async{


        setState(() {
            user= us;
        });


        var ref2 = Firestore.instance.collection('Organisations')
            .document(user.uid);
        ref2.get().then((data) {
            setState(() {
                name = data['Name'].toString();
            });
        });

    });

  }


//    void signOut() async{
//
//
//        print(_googleSignIn.currentUser);
//        await _auth.signOut();
//        _googleSignIn.signOut();
//
//
//    }

    @override
    Widget build(BuildContext context) {

        return Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                    DrawerHeader(

                        decoration: BoxDecoration(
                            color: Colors.blue,
                            image:DecorationImage(
                                fit: BoxFit.fill,
                                image:  AssetImage('assets/images/drawer_header_background.png'))

                        ),
                        child: Stack(children: <Widget>[
                            Positioned(
                                bottom: 8.0,
                                left: 18.0,
                                right: 0.0,
                                child: (user!=null && name!=null?ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: (user.providerData[1].providerId!='google')?
                                        AssetImage('assets/images/user.png'):NetworkImage(user.photoUrl),
                                    ),
                                    title: Text((user.providerData[1].providerId!='google')?'$name':'${user.displayName}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500),),

                                ):Text("Help4Real",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500))
                                ),
                            ),
                        ],),)
                    ,
                    ListTile(
                        leading: Icon(Icons.dashboard),
                        title: Text('Dashboard'),
                        onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pushNamed(context,'/');
                        },
                    ),
                    ListTile(
                        leading: Icon(Icons.input),
                        title: Text('Login'),
                        onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pushNamed(context,'/login');
                        },
                    ),
                    ListTile(
                        leading: Icon(Icons.domain),
                        title: Text('Register as Organization'),
                        onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pushNamed(context,'/Signup');
                            obj.getUser();
                        },
                    ),
                    ListTile(
                        leading: Icon(Icons.group_add),
                        title: Text('Register as Helper'),
                        onTap: () {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pushNamed(context,'/Signup2');
                        },
                    ),
                    ListTile(
                        leading: Icon(Icons.person),
                        title: Text('My Profile'),
                        onTap: () async{
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.pushNamed(context,'/MyProfile');
                        },
                    ),
                    ListTile(
                        leading: Icon(Icons.fiber_new),
                        title: Text('Post'),
                        onTap: () {
                            Navigator.pushNamed(context,'/Post');
                        },
                    ),

                    ListTile(
                        leading: Icon(Icons.power_settings_new),
                        title: Text('Sign Out'),
                        onTap: () {
                            _authenticationService.signOut();//signOut();
                        },
                    ),

                ],
            ),
        );
    }
}
