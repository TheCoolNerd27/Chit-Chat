import 'package:get_it/get_it.dart';
import 'package:chitchat/auth_service.dart';
GetIt locator = GetIt.instance;

void setupLocator() {

    locator.registerLazySingleton(() => AuthenticationService());

}