import 'package:get_it/get_it.dart';
import 'package:chitchat/auth_service.dart';
import 'package:chitchat/push_notifications.dart';
GetIt locator = GetIt.instance;

void setupLocator() {

    locator.registerLazySingleton(() => AuthenticationService());
    locator.registerLazySingleton(() => PushNotificationsManager());
}