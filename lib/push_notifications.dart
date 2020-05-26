import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {

    PushNotificationsManager._();

    factory PushNotificationsManager() => _instance;

    static final PushNotificationsManager _instance = PushNotificationsManager._();

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    bool _initialized = false;

    Future init()async{

        _firebaseMessaging.configure(
            onMessage: (Map<String, dynamic> message) async {
                print("onMessage: $message");
            },
            onLaunch: (Map<String, dynamic> message) async {
                print("onLaunch: $message");
            },
            onResume: (Map<String, dynamic> message) async {
                print("onResume: $message");
            },
        );
    }

    Future<String> getToken() async {
        String token;



        // For testing purposes print the Firebase Messaging token
        token = await _firebaseMessaging.getToken();
        print("FirebaseMessaging token: $token");


        _initialized = true;

        return token;
    }

}