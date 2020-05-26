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

                const sentBy=snapshot.data().idFrom;
                var rfn=db.collection('Users').doc(sentBy).get();
                var name=rfn.data().Name;
                const token=rfn.data().Token;
                var pic="Display Photo";
                const payload={
                      notification: {
                        title: 'New Message!',
                        body: `${name} sent you a Message!`,
                        image:rfn.data().pic,
                        },
                      data:{
                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                        sound:'default',
                        screen:'chats'


                      }
                    };

                   fcm.sendToDevice(token, payload,options);
                });

