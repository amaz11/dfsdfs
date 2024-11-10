import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/core/widget/custom_bottom_appbar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:trealapp/module/attendence/controller/animation_button_contrroller.dart';
import 'package:trealapp/module/attendence/view/attendence_report_screen.dart';
import 'package:trealapp/module/auth/controller/auth_controller.dart';
import 'package:trealapp/module/auth/controller/drawer_controller.dart';
import 'package:trealapp/module/dashboard/view/dashboard_srceen.dart';
import 'package:trealapp/module/expense/view/expense_screen.dart';
import 'package:trealapp/module/calender/view/holiday_employee_screen.dart';
import 'package:trealapp/module/home/controller/landing_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:trealapp/module/home/view/widget/arrover_botton_icon_skeleton.dart';
import 'package:trealapp/module/leaves/view/approver/approver_leave_request_screen.dart';
// import 'package:trealapp/module/leaves/view/leave_summary_screen.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});
  final AuthController loginController = Get.find<AuthController>();
  final DrawerControllerr drawerController = Get.find<DrawerControllerr>();

  final AnimatedButtonController animationController =
      Get.find<AnimatedButtonController>();
  @override
  Widget build(BuildContext context) {
    final LandingController controller = Get.find<LandingController>();
    // print(controller.notificatitonUreadDataLength.value != 0);
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          _handleBackNavigation(didPop, controller);
        },
        child: Scaffold(
            extendBody: true,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                    Icons.menu), // You can change this to any other icon
                onPressed: () {
                  // drawerController.fetchProfile();
                  Scaffold.of(context).openDrawer(); // Manually open the drawer
                },
              ),
              // automaticallyImplyLeading: true,
              title: Obx(() {
                if (controller.listOfStrings.isNotEmpty) {
                  return Text(
                    controller.tabIndex.value == 3
                        ? controller.canManageLeave.value ||
                                controller.canManageExpense.value
                            ? "Approval"
                            : "Calender"
                        : controller.listOfStrings[controller.tabIndex.value],
                    style: TextStyles.title16.copyWith(color: grayColor),
                  );
                } else {
                  return Text(
                    'Loading...',
                    style: TextStyles.title16.copyWith(color: grayColor),
                  ); // Fallback text while data is loading
                }
              }),
              shadowColor: Colors.black26,
              // elevation: 1,
              backgroundColor: Colors.white,
              actions: <Widget>[
                GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.notification);
                    },
                    child: Stack(
                      children: [
                        const Icon(CupertinoIcons.bell),
                        Obx(() =>
                            controller.notificatitonUreadDataLength.value != 0
                                ? const Positioned(
                                    top: 2,
                                    right: 4,
                                    child: CircleAvatar(
                                      radius: 3.5,
                                      backgroundColor: blueColor,
                                    ),
                                  )
                                : const SizedBox()),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            body: PageView(
              // index: controller.tabIndex.value,
              controller: controller.pageController,
              onPageChanged: (index) {
                controller.changeTabIndex(index);
              },
              children: [
                const DashboardSrceen(),
                AttendenceReportScreen(),
                const ExpenseScreen(),
                Obx(() {
                  if (controller.canManageLeave.value ||
                      controller.canManageExpense.value) {
                    return ApproverLeaveRequestScreen();
                  } else {
                    return HolidayEmployeeScreen();
                  }
                }),
              ],
            ),
            bottomNavigationBar: Theme(
                data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                child: _buildBottomNavigationMenu(context, controller)
                // child: _bottomBar(),
                ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _flotingActionButtton(controller)),
      ),
    );
  }

  Widget _flotingActionButtton(controller) {
    return Obx(() {
      if (controller.tabIndex.value == 0) {
        // Show Icon when tabIndex is 0
        return FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: whiteColor,
          child: Icon(Icons.fingerprint,
              color: animationController.todayCheckInOutColor.value, size: 28),
          onPressed: () async {
            Get.toNamed(AppRoutes.attdenceSubmitScreen);
            await animationController.reFatchGetCurrentlocation();
          },
        );
      } else {
        // Show SpeedDial for other tabIndex values
        return SpeedDial(
          iconTheme: const IconThemeData(
            size: 28,
          ),
          icon: Icons.add,
          foregroundColor:
              blueColor, // Color of the icon when SpeedDial is closed
          activeForegroundColor: redColor,
          activeIcon: Icons.close, // Icon for open menu
          backgroundColor: whiteColor,
          activeBackgroundColor: whiteColor,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          curve: Curves.bounceIn,
          spacing: 0,
          spaceBetweenChildren: 5,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.add,
                size: 20,
              ),
              shape: const CircleBorder(),
              backgroundColor: cyanColor,
              foregroundColor: whiteColor,
              label: 'Add Leave',
              labelStyle: TextStyles.regular14.copyWith(color: grayColor),
              onTap: () => Get.toNamed(AppRoutes.addLeaveScreen),
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.attach_money_rounded,
                size: 20,
              ),
              shape: const CircleBorder(),
              backgroundColor: blueColor,
              foregroundColor: whiteColor,
              label: 'Add Expense',
              labelBackgroundColor: whiteColor,
              labelStyle: TextStyles.regular14.copyWith(color: grayColor),
              onTap: () => Get.toNamed(AppRoutes.addExpenseScreen),
            ),
          ],
        );
      }
    });
  }

  Widget _buildBottomNavigationMenu(context, landingPageController) {
    Map bottomAppBarMargin = {
      'left': 10.0,
      'right': 10.0,
      'bottom': 10.0,
      'top': 0.0,
    };
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Container(
          margin: EdgeInsets.only(
            left: bottomAppBarMargin['left'],
            right: bottomAppBarMargin['right'],
            bottom: bottomAppBarMargin['bottom'],
            top: bottomAppBarMargin['top'],
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CustomBottomAppBar(
              positionInHorizontal: (0.0 - bottomAppBarMargin['left']),
              clipBehavior: Clip.antiAlias,
              notchMargin: 5,
              shape: const CircularNotchedRectangle(),
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildNavigationItem(
                      icon: Icons.home_outlined,
                      label: 'Home',
                      selected: landingPageController.tabIndex.value == 0,
                      onTap: () => _onTabSelected(landingPageController, 0),
                      leftPadding: 10,
                      rightPadding: 10,
                    ),
                  ),
                  Expanded(
                    child: _buildNavigationItem(
                      icon: Icons.access_time,
                      label: 'Attendance',
                      selected: landingPageController.tabIndex.value == 1,
                      onTap: () => _onTabSelected(landingPageController, 1),
                      leftPadding: 10,
                      rightPadding: 15,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildNavigationItem(
                      icon: Icons.monetization_on_outlined,
                      label: 'Expense',
                      selected: landingPageController.tabIndex.value == 2,
                      onTap: () => _onTabSelected(landingPageController, 2),
                      leftPadding: 35,
                      rightPadding: 5,
                    ),
                  ),
                  Obx(() {
                    if (landingPageController.isApproverLoading.value) {
                      // Show skeleton loader while data is loading
                      return const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: ArroverBottonIconSkeleton(),
                        ),
                      );
                    }

                    // Normal UI when data is loaded
                    final label = landingPageController.canManageLeave.value ||
                            landingPageController.canManageExpense.value
                        ? 'Approval'
                        : 'Calendar';
                    final icon = landingPageController.canManageLeave.value ||
                            landingPageController.canManageExpense.value
                        ? Icons.description_outlined
                        : Icons.calendar_month_outlined;
                    return Expanded(
                      child: _buildNavigationItem(
                        icon: icon,
                        label: label,
                        selected: landingPageController.tabIndex.value == 3,
                        onTap: () => _onTabSelected(landingPageController, 3),
                        leftPadding: 10,
                        rightPadding: 10,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        )));
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required double leftPadding,
    required double rightPadding,
  }) {
    final color = selected ? blueColor : lightGrayColor2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: whiteColor,
        child: Padding(
          padding:
              EdgeInsets.only(left: leftPadding, right: rightPadding, top: 10),
          child: Center(
            child: Column(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(height: 2),
                Text(label, style: TextStyles.regular10.copyWith(color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTabSelected(LandingController controller, int index) {
    controller.changeTabIndex(index);
    controller.pageController.jumpToPage(index);
  }

  bool _handleBackNavigation(bool didPop, LandingController controller) {
    if (controller.tabIndex.value != 0) {
      // If not on the first page, navigate to the first page
      _onTabSelected(controller, 0);
      return false; // Prevent exiting the app
    } else {
      // controller.setCanPop(true); // Set canPop to true
      // print("==================${controller.canPop.value}==================");
      // If on the first page, show the exit confirmation dialog
      _showExitDialog(controller);
      return true; // Prevent exiting until the user confirms
    }
  }

  void _showExitDialog(LandingController controller) {
    DialogUtils().showConfirmationDialog(
        colors: redColor,
        content: 'Are you sure you want to exit the app?',
        onConfirm: () {
          SystemNavigator.pop();
          // Set canPop to true
        },
        text: "Exit",
        title: "Exit App");
  }
}

// FloatingActionButton(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//           backgroundColor: whiteColor,
//           tooltip: 'Increment',
//           onPressed: () {
//             switch (controller.tabIndex.value) {
//               case 0:
//                 Get.toNamed(AppRoutes.attdenceSubmitScreen);
//                 animationController.reFatchGetCurrentlocation();
//                 break;
//               case 1:
//                 Get.toNamed(AppRoutes.addExpenseScreen);
//                 break;
//               case 2:
//                 Get.toNamed(AppRoutes.addLeaveScreen);
//                 break;
//               case 3:
//                 Get.toNamed(AppRoutes.addExpenseScreen);
//                 break;
//               default:
//             }
//           },
//           child: Obx(() {
//             if (controller.tabIndex.value == 0) {
//               // Show Icon when tabIndex is 0
//               return const Icon(Icons.fingerprint, color: blueColor, size: 28);
//             } else {
//               // Show PopupMenuButton for other tabIndex values
//               return PopupMenuButton<String>(
//                 // color: Colors.transparent,
//                 icon: const Icon(Icons.add,
//                     color: blueColor, size: 28), // Icon for the popup menu
//                 onSelected: (value) {
//                   // Handle menu item selection
//                   if (value == 'Option 1') {
//                     Get.toNamed(AppRoutes.addLeaveScreen);
//                   } else if (value == 'Option 2') {
//                     Get.toNamed(AppRoutes.addExpenseScreen);
//                   }
//                 },
//                 itemBuilder: (BuildContext context) {
//                   return [
//                     const PopupMenuItem<String>(
//                       value: 'Option 1',
//                       child: Text('Add Leave'),
//                     ),
//                     const PopupMenuItem<String>(
//                       value: 'Option 2',
//                       child: Text('Add Expense'),
//                     ),
//                     // Add more PopupMenuItems as needed
//                   ];
//                 },
//               );
//             }
//           }),
//         ),

// final TextStyle unselectedLabelStyle = TextStyle(
//     color: Colors.white.withOpacity(0.5),
//     fontWeight: FontWeight.w500,
//     fontSize: 12);

// final TextStyle selectedLabelStyle = const TextStyle(
//     color: Colors.black, fontWeight: FontWeight.w500, fontSize: 10);

// buildBottomNavigationMenu(context, landingPageController) {
//   return Obx(() => MediaQuery(
//       data: MediaQuery.of(context)
//           .copyWith(textScaler: const TextScaler.linear(1.0)),
//       child: Container(
//         decoration: BoxDecoration(
//           color: whiteColor,
//           borderRadius: const BorderRadius.all(Radius.circular(50)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//               // changes position of shadow
//             ),
//           ],
//         ),
//         height: 57,
//         margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//         padding: const EdgeInsets.only(top: 2, bottom: 2),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           elevation: 0.0,
//           showUnselectedLabels: true,
//           showSelectedLabels: true,
//           onTap: (index) {
//             landingPageController.changeTabIndex(index);
//             _pageController.jumpToPage(index);
//           },
//           currentIndex: landingPageController.tabIndex.value,
//           backgroundColor: Colors.transparent,
//           unselectedItemColor: lightGrayColor2,
//           selectedItemColor: blueColor,
//           unselectedLabelStyle: unselectedLabelStyle,
//           selectedLabelStyle: selectedLabelStyle,
//           items: [
//             BottomNavigationBarItem(
//               icon: Container(
//                 margin: const EdgeInsets.only(bottom: 4),
//                 child: const Icon(
//                   Icons.home_outlined,
//                   size: 20.0,
//                 ),
//               ),
//               label: 'Home',
//               backgroundColor: const Color(0xFF243665),
//             ),
//             BottomNavigationBarItem(
//               icon: Container(
//                 margin: const EdgeInsets.only(bottom: 4),
//                 child: const Icon(
//                   Icons.access_time,
//                   size: 20.0,
//                 ),
//               ),
//               label: 'Attendence',
//               backgroundColor: const Color(0xFF243665),
//             ),
//             BottomNavigationBarItem(
//               icon: Container(
//                 margin: const EdgeInsets.only(bottom: 4),
//                 child: const Icon(
//                   Icons.description_outlined,
//                   size: 20.0,
//                 ),
//               ),
//               label: 'Approval',
//               backgroundColor: const Color(0xFF243665),
//             ),
//           ],
//         ),
//       )));
// }
