import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_encyclopedia/src/screen/categories_screen.dart';
import 'package:software_encyclopedia/src/screen/community_screen.dart';
import 'package:software_encyclopedia/src/screen/dashboard_screen.dart';
import 'package:software_encyclopedia/src/screen/profile_screen.dart';
import 'package:software_encyclopedia/src/utils/app_colors.dart';

import 'login_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

   void _showLogoutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: AppColors.primaryColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm', style: TextStyle(color: AppColors.primaryColor),),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('appIsLoggedIn', false);
                prefs.reload();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ModalRoute.withName('/login'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Color isSelected(int index) {
    if (selectedIndex == index) {
      return AppColors.primaryColor;
    } else {
      return AppColors.blackColor;
    }
  }

  bottomBar() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (index) {
        selectedIndex = index;
        setState(() {});
      },
      selectedItemColor: AppColors.blackColor,
      backgroundColor: AppColors.canvasColor,
      items: [
        BottomNavigationBarItem(
          label: '',
          icon: Icon(
            size: 40,
            Icons.home,
            color: isSelected(0),
            weight: 25,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(
            size: 40,
            Icons.category_rounded,
            color: isSelected(1),
            weight: 25,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(
            size: 40,
            Icons.groups,
            color: isSelected(2),
            weight: 25,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(
            size: 40,
            Icons.person,
            color: isSelected(3),
            weight: 25,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.canvasColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: AppColors.primaryShadowColor,
          centerTitle: true,
          title: selectedIndex == 0
              ? const Text(
                  'Software Encyclopedia',
                  style: TextStyle(color: AppColors.primaryColor),
                )
              : selectedIndex == 1 ? const Text(
                  'Categories',
                  style: TextStyle(color: AppColors.primaryColor),
                )  : selectedIndex == 2 ? const Text(
                  'Community',
                  style: TextStyle(color: AppColors.primaryColor),
                )  :  const Text('Personal Details', style: TextStyle(color: AppColors.primaryColor),),
          actions: [
            selectedIndex == 0 ? IconButton(
            onPressed: () async {
              _showLogoutAlert(context);
            },
            icon: const Icon(
              Icons.logout,
              color: AppColors.primaryColor,
            ),
          ) : const SizedBox()
          ],
        ),
      ),
      body: PopScope(
        onPopInvoked: (didPop) async {
          if (selectedIndex == 0) {
            didPop = true;
          } else {
            didPop = false;
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 200,
          ),
          child: IndexedStack(
            index: selectedIndex,
            children: const [
              DashboardScreen(),
              CategoriesScreen(),
              CommunityScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(),
    );
  }
}
