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
import 'home_controller.dart';

// ... your other imports ...

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthController _authController = Get.put(AuthController());
  final HomeController _homeController = Get.put(HomeController());

  final List<Widget> _tabs = [
    const HomeTab(),
    WishlistTab(),
    Center(child: Text("Coming Soon")),
    const CartTab(),
    const ProfileTab(),
  ];

  // WhatsApp group link (replace with your actual link)
  final String whatsappGroupLink = "https://chat.whatsapp.com/DcmnzTm3xTIJTHzREOYKQs";
  final String privacyPolicy = "https://dazzlefashionindia.blogspot.com/2025/06/dazzle-fashion-privacy-policy.html";
  final String appLink = "https://dazzlefashionindia.blogspot.com/2025/06/dazzle-fashion-privacy-policy.html";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchUrl(Uri.parse("https://wa.me/message/AVKOG6O7HBVII1"));
        },
        backgroundColor: Colors.transparent,
        child: Image.asset("assets/whatsapp.png"),
      ),
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: Text(
          "Dazzle's Fashion",
          style: GoogleFonts.poppins(color: Theme.of(context).primaryColor, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Theme.of(context).primaryColor),
            onPressed: _authController.signOut,
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Obx(() => _tabs[_homeController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _homeController.currentIndex.value,
          onTap: _homeController.setIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.borderGray,
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'MTO'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.primaryColor.withOpacity(1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // DrawerHeader(
          //   decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          //   child:
          // ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(AppAssets.logoPath, height: 250, width: 250),
              // const SizedBox(height: 8),
              // Text("Dazzle's Fashion", style: GoogleFonts.poppins(color: Theme.of(context).primaryColor, fontSize: 24, fontWeight: FontWeight.w600)),
              // const SizedBox(height: 8),
              // Text('Welcome to our store', style: GoogleFonts.poppins(color: Theme.of(context).primaryColor.withOpacity(0.7), fontSize: 14)),
            ],
          ),
          Divider(),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              _homeController.setIndex(0);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.category,
            title: 'Catalog',
            onTap: () {
              // Navigate to catalog screen
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.group,
            title: 'Join WhatsApp Community',
            onTap: () async {
              Navigator.pop(context);
              if (await canLaunch(whatsappGroupLink)) {
                await launch(whatsappGroupLink);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch WhatsApp')));
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.info,
            title: 'About Us',
            onTap: () async {
              Navigator.pop(context);
              if (await canLaunch(privacyPolicy)) {
                await launch(privacyPolicy);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch WhatsApp')));
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.share,
            title: 'Share App',
            onTap: () async {
              Navigator.pop(context);
              if (await canLaunch(appLink)) {
                await launch(appLink);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch WhatsApp')));
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () async {
              // Navigate to privacy policy screen
              Navigator.pop(context);
              if (await canLaunch(privacyPolicy)) {
                await launch(privacyPolicy);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch WhatsApp')));
              }
            },
          ),
          Divider(color: Colors.white),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              Navigator.pop(context);
              _authController.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
      onTap: onTap,
    );
  }
}
