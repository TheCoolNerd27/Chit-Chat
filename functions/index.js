const functions = require('firebase-functions');

const admin = require('firebase-admin');

var serviceAccount = require("./chitchat.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://chitchat-a6cff.firebaseio.com"
});
var obj=[];
var chatid;
const notification_options = {
    priority: "high",
    timeToLive: 60 * 60 * 24
  };
let db=admin.firestore();
const options =  notification_options;
const fcm = admin.messaging();
exports.chatList=functions.auth.user().onCreate((user) => {

	// const user = event.data;

    var ref=db.collection('Users').get()
    .then((snapshot)=>{
    snapshot.forEach((doc)=>{
      
        if(doc.id<user.uid)
        chatid=doc.id+user.uid;
        else if(doc.id>user.uid)
        chatid=user.uid+doc.id;
        
        console.log("DOC-ID=",doc.id);
        console.log("USer=",user.uid);
        if(user.uid!==doc.id)
    obj.push({
        chatid:chatid,
        User1:doc.data().email,
        User2:user.email,
    

    });

       });

       obj.forEach((doc)=>{
        if(doc.User1!==doc.USer2)
        var ref2=db.collection('Chats').doc(doc.chatid).set({
            User1:doc.User1,
            USer2:doc.User2,
        });


       });
       
       
       
       
       return;
    }).catch(err=>{
    console.log(err);
    });


});

exports.notify=functions.firestore.document('Chats/{cid}/Messages/{mid}')
                .onCreate((snapshot)=>{
                var token,pic,name,payload;
                const sentTo=snapshot.data().idTo;
                const sent=snapshot.data().idFrom;
                name=snapshot.data().nameFrom;
                var rfn=db.collection('Users').doc(sentTo);
                rfn.get().then(async (snap)=>{
                 
                 token=await snap.data().Token;
                 pic="Display Photo";
                 payload={
                      notification: {
                        title: 'New Message!',
                        body: `${name} sent you a Message!`,
                        image:'https://firebasestorage.googleapis.com/v0/b/chitchat-a6cff.appspot.com/o/Media%2Fic_launcher-web.png?alt=media&token=4d49b8a1-e33e-43a8-aa9a-fc05ed6ba982'
                        },
                      data:{
                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                        sound:'default',
                        screen:'chats'


                      }
                    };
                    return null;

                }).then(()=>{
                  return fcm.sendToDevice(token, payload);
                }).catch(err=>console.log(err));

                

                   
                });