const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
var obj=[];
var chatid;
let db=admin.firestore();
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

