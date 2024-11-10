import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_assets.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/const_key.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/drawer_item.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/auth/controller/auth_controller.dart';
import 'package:trealapp/module/auth/controller/drawer_controller.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthController loginController = Get.find<AuthController>();
  final DrawerControllerr drawerController = Get.find<DrawerControllerr>();
  String? name;
  String? designation;
  String? userprofileImg;
  @override
  void initState() {
    super.initState();
    // drawerController.fetchProfile();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.profileScreen);
              Scaffold.of(context).closeDrawer();
            },
            child: Container(
              height: 100,
              // color: redColor,
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: lightGrayColor2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        // ignore: unnecessary_null_comparison
                        child:
                            // Obx(() {
                            //   if (drawerController.isLoading.value) {
                            //     return const SizedBox(
                            //       width: 10,
                            //     );
                            //   }
                            // ignore: unrelated_type_equality_checks
                            // return
                            // ignore: unnecessary_null_comparison
                            userprofileImg == null ||
                                    userprofileImg == "" ||
                                    userprofileImg == "null"
                                ? Image.asset(
                                    profileImg) // Default profile image
                                : Image.network(userprofileImg!)
                        // }),
                        ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Obx(() {
                        //   if (drawerController.isLoading.value) {
                        //     return const SizedBox(
                        //       width: 10,
                        //     );
                        //   }
                        //   return
                        Text(
                          name ?? "",
                          style: TextStyles.title18.copyWith(color: grayColor),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        // }),
                        // Obx(() {
                        //   if (drawerController.isLoading.value) {
                        //     return const SizedBox(
                        //       width: 10,
                        //     );
                        //   }
                        //   return
                        Text(
                          designation ?? "",
                          style: TextStyles.regular14
                              .copyWith(color: lightGrayColor2),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        )
                        // })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBoxHight(
            hieght: 15,
          ),
          // DrawerItem(
          //     title: "Home", icon: Icons.home, path: AppRoutes.homeScreen),
          Container(
            padding: EdgeInsets.only(left: Dimensions.padding15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.padding08),
                  child: Text(
                    "App Feature",
                    style: TextStyles.title18
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                DrawerItem(
                  title: "Attendence Report",
                  icon: Icons.access_time,
                  path: AppRoutes.homeScreen,
                  homeScreen: true,
                  pageViewNumber: 1,
                ),
                DrawerItem(
                  title: "Expence",
                  icon: Icons.monetization_on_outlined,
                  path: AppRoutes.homeScreen,
                  homeScreen: true,
                  pageViewNumber: 2,
                ),
                DrawerItem(
                  title: "Leave Summary",
                  icon: Icons.description_outlined,
                  path: AppRoutes.leaveSummary,
                  // homeScreen: true,
                  // pageViewNumber: 2,
                ),
                DrawerItem(
                  title: "Personalized Calender",
                  icon: Icons.calendar_month_outlined,
                  path: AppRoutes.holidays,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: Dimensions.padding10, bottom: Dimensions.padding08),
                  child: Text(
                    "Settings",
                    style: TextStyles.title16
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                DrawerItem(
                    title: "Profile",
                    icon: Icons.person,
                    path: AppRoutes.profileScreen),
                DrawerItem(
                    title: "Change Password",
                    icon: Icons.password,
                    path: AppRoutes.changePassword),
                DrawerItem(
                    title: "File Download",
                    icon: Icons.download,
                    path: AppRoutes.fileDownloadTest),
              ],
            ),
          ),
          Expanded(child: Container()),
          const Divider(
            height: 2,
          ),
          Builder(builder: (context) {
            return ListTile(
              // contentPadding: const EdgeInsets.only(left: 1),
              minTileHeight: 48,
              horizontalTitleGap: 5,
              leading: const Icon(
                Icons.logout_outlined,
                size: 20,
              ),
              title: Text(
                "Log Out",
                style: TextStyles.regular16Thin300,
              ),
              onTap: () {
                loginController.logoutMethod();
                Scaffold.of(context).closeDrawer();
              },
            );
          }),
        ],
      ),
    );
  }

  Future<void> _getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPreferences.getString(AppConstantkey.USERNAME.key);
      designation = sharedPreferences.getString(AppConstantkey.DESIGNATION.key);
      userprofileImg =
          sharedPreferences.getString(AppConstantkey.PROFILE_IMG.key)!;
    });
  }
}
