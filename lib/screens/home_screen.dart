import 'dart:convert';

import 'package:betus/assets/app_colors.dart';
import 'package:betus/controller/ConfigurationController.dart';
import 'package:betus/data/entity/configuration_entity.dart';
import 'package:betus/screens/bottom_sheets/account_bottom_sheet.dart';
import 'package:betus/screens/bottom_sheets/logout_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:state_extended/state_extended.dart';
import 'package:http/http.dart' as http;

import '../controller/UserController.dart';
import '../data/entity/account/user.dart';
import '../data/local/preference_manager.dart';
import '../data/remote/api_error.dart';
import '../data/remote/api_response.dart';
import '../utils/helper/alert_helper.dart';
import '../utils/helper/helper.dart';
import 'bottom_sheets/delete_account_bottom_sheet.dart';
import 'bottom_sheets/menu_bottom_sheet.dart';
import 'hub_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  StateX<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends StateX<HomeScreen> {
  int _currentIndex = 0;
  bool _isFABOpen = false;
  bool _isEmailVerified = false;
  User user = User();
  late UserController userController;

  // List of tabs for the bottom navigation bar
  /*final List<Widget> _pages = [
    Center(child: Text("WebView Screen", style: TextStyle(fontSize: 24, color: AppColors.white))),
    Center(child: Text("Menu Bottom sheet", style: TextStyle(fontSize: 24, color: AppColors.white))),
    Center(child: Text("Account screen", style: TextStyle(fontSize: 24, color: AppColors.white))),
  ];*/
  _HomeScreenState() : super(controller: UserController()) {
    // Acquire a reference to the passed Controller.
    userController = controller as UserController;
  }

  final List<Widget> _pages = [HubScreen(), Placeholder(), Placeholder()];

  void _toggleFAB() {
    setState(() {
      _isFABOpen = !_isFABOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!PreferenceManager.getIsLoginScreenOpen()) {
      _callLoginApi();
    }
    else{
      PreferenceManager.setIsLoginScreenOpen(false);
    }
  }

  Future<void> _callLoginApi() async {
    Helper.isInternetConnectionAvailable().then((internet) async {
      if (internet) {
        setData();
        await userController.login(user).then((value) async {
          if (value is APIResponse) {
            setState(() {
              userController.isApiCall = false;
            });
            PreferenceManager.setIsLoginScreenOpen(false);
          } else {
            if (value is APIError) {
              setState(() {
                userController.isApiCall = false;
              });
              //AlertHelper.customSnackBar(context, value.message, true);
            }
          }
        });
      } else {
        setState(() {
          userController.isApiCall = false;
        });
        //AlertHelper.customSnackBar(context, S.of(context).err_internet, true);
      }
    });
  }

  void setData() {
    setState(() {
      user.email = PreferenceManager.getEmail();
      user.password = PreferenceManager.getPassword();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFL'),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.notifications),
          )
        ],
      ),
      body: Stack(
        children: [
          _pages[_currentIndex],
          if (_isFABOpen) ...[
            // Overlay for FAB options
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleFAB,
                child: Container(color: Colors.black54),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildFABOption(Icons.logout, "Logout", Colors.blue),
                  _buildFABOption(Icons.delete, "Delete Account", Colors.blue),
                  _buildFABOption(Icons.person, "Profile", Colors.red),
                  _buildFABOption(
                      Icons.close, "Close", Colors.blue, _toggleFAB),
                ],
              ),
            ),
          ],
        ],
      ),
/*      floatingActionButton: SpeedDial(
        //Speed dial menu
        marginBottom: 10,
        //margin bottom
        icon: Icons.menu,
        //icon on Floating action button
        activeIcon: Icons.close,
        //icon when menu is expanded on button
        backgroundColor: Colors.deepOrangeAccent,
        //background color of button
        foregroundColor: Colors.white,
        //font color, icon color in button
        activeBackgroundColor: Colors.deepPurpleAccent,
        //background color when menu is expanded
        activeForegroundColor: Colors.white,
        buttonSize: 56.0,
        //button size
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        // action when menu opens
        onClose: () => print('DIAL CLOSED'),
        //action when menu closes

        elevation: 8.0,
        //shadow elevation of button
        shape: CircleBorder(),
        //shape of button

        children: [
          SpeedDialChild(
            child: Icon(Icons.person, color: AppColors.white),
            foregroundColor: AppColors.white,
            backgroundColor: AppColors.carrot,
            label: 'Not Verified, Click to Verify',
            labelStyle: TextStyle(fontSize: 14.0),
            onTap: () => print('THIRD CHILD'),
            onLongPress: () => print('THIRD CHILD LONG PRESS'),
            shape: CircleBorder(),
          ),
          SpeedDialChild(
            child: Icon(Icons.delete, color: AppColors.white),
            backgroundColor: AppColors.darkBlue,
            foregroundColor: AppColors.white,
            label: 'Delete Account',
            labelStyle: TextStyle(fontSize: 14.0),
            onTap: () => _openDeleteAccountBottomSheet(context),
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
            shape: CircleBorder(),
          ),
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.exit_to_app, color: AppColors.white),
            backgroundColor: AppColors.darkBlue,
            foregroundColor: AppColors.white,
            label: 'Logout',
            labelStyle: TextStyle(fontSize: 14.0),
            onTap: () => _openLogoutBottomSheet(context),
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
            shape: CircleBorder(),
          ),
          //add more menu item childs here
        ],
      ),*/
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.bottomNavBg,
        selectedItemColor: AppColors.darkBlue,
        unselectedItemColor: AppColors.white,
        selectedLabelStyle: const TextStyle(color: AppColors.white),
        unselectedLabelStyle: const TextStyle(color: AppColors.white),
        currentIndex: _currentIndex,
        onTap: (index) {
/*          setState(() {
            _currentIndex = index;
          });*/
          /*if (index == 1) {
            _openMenuBottomSheet(context);
          } else */
          if (index == 1) {
            _openAccountBottomSheet(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Hub"),
          /*BottomNavigationBarItem(
              icon: Icon(Icons.menu, color: AppColors.white), label: "Menu"),*/
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: "Account"),
        ],
      ),
    );
  }

  Widget _buildFABOption(IconData icon, String label, Color color,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap ?? () => print(label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _openMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MenuBottomSheet();
      },
    ).then((_) {
      setState(() {
        _currentIndex = 0; // Return to Hub when the sheet is closed
      });
    });
  }

  void _openLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return LogoutBottomSheet();
      },
    ).then((_) {
      setState(() {
        _currentIndex = 0; // Return to Hub when the sheet is closed
      });
    });
  }

  void _openDeleteAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DeleteAccountBottomSheet();
      },
    ).then((_) {
      setState(() {
        _currentIndex = 0; // Return to Hub when the sheet is closed
      });
    });
  }

  void _openAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return AccountBottomSheet();
      },
    ).then((_) {
      setState(() {
        _currentIndex = 0; // Return to Hub when the sheet is closed
      });
    });
  }
}
