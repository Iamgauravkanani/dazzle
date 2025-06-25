import 'dart:io';

import 'package:dazzle_app/controllers/auth_controller.dart';
import 'package:dazzle_app/screens/home/tabs/cart_tab.dart';
import 'package:dazzle_app/screens/home/tabs/home_tab.dart';
import 'package:dazzle_app/screens/home/tabs/profile_tab.dart';
import 'package:dazzle_app/screens/home/tabs/wishlist_tab.dart';
import 'package:dazzle_app/utils/assets.dart';
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Initialize controllers using GetX for state management
  final AuthController _authController = Get.put(AuthController());
  final HomeController _homeController = Get.put(HomeController());

  // List of widgets to be displayed as tabs
  final List<Widget> _tabs = [
    const HomeTab(),
    WishlistTab(), // Assuming WishlistTab is a screen/widget
    const Center(child: Text("Coming Soon")), // Placeholder for MTO tab
    const CartTab(),
    const ProfileTab(),
  ];

  // URLs and Links
  final String whatsappGroupLink = "https://chat.whatsapp.com/DcmnzTm3xTIJTHzREOYKQs";
  final String whatsappBusinessLink = "https://wa.me/message/AVKOG6O7HBVII1";
  final String privacyPolicy = "https://dazzlefashionindia.blogspot.com/2025/06/dazzle-fashion-privacy-policy.html";
  final String appLink = "https://dazzlefashionindia.blogspot.com/2025/06/dazzle-fashion-privacy-policy.html";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// --- NEW: Method to show the exit confirmation dialog ---
  /// This function returns a Future<bool>. `true` allows the app to exit, `false` prevents it.
  Future<bool> _onWillPop(BuildContext context) async {
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            title: Text(
              'Confirm Exit',
              style: GoogleFonts.poppins(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
            ),
            content: Text('Are you sure you want to exit the app?', style: GoogleFonts.poppins(color: Colors.black87)),
            actions: <Widget>[
              // "No" button
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Returns false
                child: Text(
                  'No',
                  style: GoogleFonts.poppins(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                ),
              ),
              // "Yes" button
              ElevatedButton(
                onPressed: () {
                  exit(0);
                }, // Returns true
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: Text('Yes', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
    );

    // If shouldExit is null (dialog dismissed by tapping outside), default to false.
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final double appBarFontSize = isTablet ? 24 : 22;
    final double navLabelFontSize = isTablet ? 14 : 12;
    final double drawerFontSize = isTablet ? 18 : 16;
    final double iconSize = isTablet ? 32 : 28;
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppTheme.backgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            launchUrl(Uri.parse(whatsappBusinessLink));
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Image.asset(
            "assets/whatsapp.png", // Ensure this asset exists
            width: 60,
            height: 60,
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 1,
          shadowColor: Colors.grey.withOpacity(0.2),
          title: Text(
            "Dazzle's Fashion",
            style: GoogleFonts.poppins(
              color: Theme.of(context).primaryColor,
              fontSize: appBarFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).primaryColor, size: iconSize),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: Theme.of(context).primaryColor, size: iconSize),
              onPressed: _authController.signOut,
            ),
          ],
        ),
        drawer: _buildDrawer(context, screenWidth, drawerFontSize, isTablet),
        body: SafeArea(
          // Obx rebuilds the body when homeController.currentIndex changes
          child: Obx(() => _tabs[_homeController.currentIndex.value]),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: _homeController.currentIndex.value,
            onTap: _homeController.setIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.borderGray,
            selectedLabelStyle: GoogleFonts.poppins(fontSize: navLabelFontSize, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: navLabelFontSize),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart_outlined),
                activeIcon: Icon(Icons.add_shopping_cart),
                label: 'MTO',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // No changes to the methods below
  Widget _buildDrawer(BuildContext context, double screenWidth, double fontSize, bool isTablet) {
    return Drawer(
      backgroundColor: AppTheme.primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppTheme.primaryColor),
            child: Center(child: Image.asset(AppAssets.logoPath, height: isTablet ? 150 : 120)),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            fontSize: fontSize,
            onTap: () {
              _homeController.setIndex(0);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.category,
            title: 'Categories',
            fontSize: fontSize,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to catalog screen
            },
          ),
          _buildDrawerItem(
            icon: Icons.group,
            title: 'Join WhatsApp Community',
            fontSize: fontSize,
            onTap: () async {
              Navigator.pop(context);
              if (!await launchUrl(Uri.parse(whatsappGroupLink))) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch WhatsApp')));
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            title: 'About Us',
            fontSize: fontSize,
            onTap: () async {
              Navigator.pop(context);
              if (!await launchUrl(Uri.parse(privacyPolicy))) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.share,
            title: 'Share App',
            fontSize: fontSize,
            onTap: () async {
              Navigator.pop(context);
              // TODO: Implement Share functionality using the `share_plus` package
            },
          ),
          _buildDrawerItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            fontSize: fontSize,
            onTap: () async {
              Navigator.pop(context);
              if (!await launchUrl(Uri.parse(privacyPolicy))) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
              }
            },
          ),
          const Divider(color: Colors.white54, thickness: 1, indent: 16, endIndent: 16),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            fontSize: fontSize,
            onTap: () {
              Navigator.pop(context);
              _authController.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required double fontSize,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: fontSize * 1.2),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.w500, color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
