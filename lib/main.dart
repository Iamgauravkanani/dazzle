import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'bindings/app_bindings.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'services/auth_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase App Check

  // Configure Firebase Auth
  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true, // Only for development
    phoneNumber: null,
    smsCode: null,
  );

  // Initialize services
  Get.put(AuthService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Dazzle Fashion',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.SPLASH,
          getPages: AppPages.routes,
          initialBinding: AppBindings(),
          defaultTransition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add your app logo here
            const Icon(Icons.shopping_bag, size: 100, color: AppTheme.secondaryColor),
            SizedBox(height: 24.h),
            Text(
              'Dazzle Fashion',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppTheme.secondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
