import 'package:dazzle_app/screens/auth/signin_screen.dart';
import 'package:dazzle_app/screens/auth/signup_screen.dart';
import 'package:dazzle_app/screens/splash_screen.dart';
import 'package:get/get.dart';
import '../screens/home/home_binding.dart';
import '../screens/home/home_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () =>  SplashScreen(),
      
    ),
    GetPage(
      name: Routes.SIGNIN,
      page: () =>  SignInScreen(),
    
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () =>  SignUpScreen(),
    
    ),
    GetPage(
      name: Routes.HOME,
      page: () =>  HomeScreen(),
      binding: HomeBinding(),
    ),
    // TODO: Add more routes as we create the screens
  ];
} 