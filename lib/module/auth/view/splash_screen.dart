import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/const_key.dart';
import 'package:trealapp/module/auth/controller/drawer_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final DrawerControllerr drawerController =
      Get.put<DrawerControllerr>(DrawerControllerr());
  bool isConnectionToInternet = false;
  // ignore: unused_field
  StreamSubscription? _internerStreamSubscription;
  @override
  void initState() {
    super.initState();
    // Timer(const Duration(seconds: 2), () {
    //   Get.toNamed(AppRoutes.loginScreen);
    // });

    _internerStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnectionToInternet = true;
          });
          _checkAuthStatus();
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectionToInternet = false;
          });
          _checkAuthStatus();
          break;
        default:
          setState(() {
            isConnectionToInternet = false;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Treal",
              style:
                  TextStyles.title24.copyWith(fontSize: 24, color: blueColor),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _checkAuthStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(AppConstantkey.TOKEN.key) ?? "";

    String? fistLogin =
        sharedPreferences.getString(AppConstantkey.FIRST_LOGIN.key) ?? "";
    // print(token);
    if (token.isNotEmpty && fistLogin.isEmpty) {
      Get.offAllNamed(AppRoutes.homeScreen);
    } else if (fistLogin == "1") {
      Get.offAllNamed(AppRoutes.changePassword);
    } else {
      Get.offAllNamed(AppRoutes.loginScreen);
      drawerController.setCurrentRoute();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _internerStreamSubscription
        ?.cancel(); // Cancel the subscription when not needed
  }
}
