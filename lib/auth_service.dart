import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
class AuthenticationService {
//    Future loginWithEmail(
//        {@required String email, @required String password}) async {
//        // TODO: implement loginWithEmail
//        FirebaseUser user;
//        try {
//            user = (await auth.signInWithEmailAndPassword(
//                email: email,
//                password: password,
//            ))
//                .user;
//
//            return user != null;
//        }
//        catch (e) {
//            return e.message;
//        }
//    }

    Future<FirebaseUser> getUSer()async{
        FirebaseUser udf=await auth.currentUser();
        return udf;

    }

    Future signInWithGoogle() async {
        try {
            final GoogleSignInAccount googleUser = await googleSignIn.signIn();
            final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
            final AuthCredential credential = GoogleAuthProvider.getCredential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
            );
            final AuthResult authResult = await auth.signInWithCredential(
                credential);

            final FirebaseUser user =
                (await auth.signInWithCredential(credential)).user;
            assert(user.email != null);
            assert(user.displayName != null);
            assert(!user.isAnonymous);
            assert(await user.getIdToken() != null);
            if (authResult.additionalUserInfo.isNewUser) {
                var ref = Firestore.instance.collection('Users').document(
                    user.uid);
                ref.setData({"email": user.email, "Name": user.displayName,"Display Photo":user.photoUrl});
            }
            else {
                print('Welcome');
            }
            final FirebaseUser currentUser = await auth.currentUser();
            assert(user.uid == currentUser.uid);
            return user != null;


        }
        catch (e) {
            return e.message;
        }
    }

//    Future osignUpWithEmail(
//        {@required String email, @required String password}) async {
//        // TODO: implement signUpWithEmail
//        try {
//            final FirebaseUser user = (await auth
//                .createUserWithEmailAndPassword(
//                email: email,
//                password: password,
//            ))
//                .user;
//
//            /*var ref=Firestore.instance.collection('Organisations').document(user.uid);
//        ref.setData({"email":user.email,"Name":name,"Desc":desc,"Address":address,"City":city,"Contact":contact});*/
//            print('$user');
//
//            return user != null;
//        }
//        catch (e) {
//            return e.message;
//        }
//    }
//    Future hsignUpWithEmail({@required String email, @required String password})
//    async {
//        try {
//            final FirebaseUser user = (await auth
//                .createUserWithEmailAndPassword(
//                email: email,
//                password: password,
//            ))
//                .user;
////            var ref = Firestore.instance.collection('Helpers').document(
////                user.uid);
////            ref.setData({"email": user.email, "Name": user.displayName});
//            print('$user');
//            return user!=null;
//        }
//        catch (e) {
//            return e.message;
//        }
//    }
    Future signOut()
   async {



            print(googleSignIn.currentUser);
            await auth.signOut();
            googleSignIn.signOut();



    }
    FirebaseAuth getInstance()
    {
        return auth;
    }
}