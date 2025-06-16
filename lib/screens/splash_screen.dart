import 'package:dazzle_app/utils/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../utils/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(SplashController controller) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackgroundImage(),
        _buildLoadingIndicator(controller),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      "assets/splash.jpg",
      fit: BoxFit.cover,
    );
  }

  Widget _buildLoadingIndicator(SplashController controller) {
    return Positioned(
      bottom: 50.h,
      left: 0,
      right: 0,
      child: Obx(() => controller.isLoading.value
          ? SizedBox(
              height: 50.h,
              width: 50.w,
              child: const Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 20,
                ),
              ),
            )
          : const SizedBox.shrink()),
    );
  }
}
