import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:trealapp/module/attendence/view/attendence_submit_screen.dart';
import 'package:trealapp/module/auth/view/splash_screen.dart';
import 'package:trealapp/module/auth/view/auth_screen.dart';
import 'package:trealapp/module/expense/view/add_expense_sreen.dart';
import 'package:trealapp/module/calender/view/calender_screen.dart';
import 'package:trealapp/module/home/view/landing_screen.dart';
import 'package:trealapp/module/internet_connction_plus/view/internet_connction.dart';
import 'package:trealapp/module/leaves/view/add_leaves_screen.dart';
import 'package:trealapp/module/leaves/view/approver/approver_leave_request_screen.dart';
import 'package:trealapp/module/leaves/view/leave_history_screen.dart';
import 'package:trealapp/module/leaves/view/leave_summary_screen.dart';
import 'package:trealapp/module/leaves/view/update_leaves_screen.dart';
import 'package:trealapp/module/notification/view/notification_screen.dart';
import 'package:trealapp/module/other/file_download_test.dart';
import 'package:trealapp/module/profile/view/profile_screen.dart';
import 'package:trealapp/module/setting/view/change_password_screen.dart';

class AppRoutes {
  static const splashScreen = '/splashScreen';
  static const connectionScreen = "/connection";
  static const loginScreen = '/login';
  static const homeScreen = '/home';
  static const attdenceSubmitScreen = '/attdencesubmit';
  static const changePassword = '/changepassword';
  static const notification = '/notification';
  static const profileScreen = '/profile';
  static const addExpenseScreen = '/add-expense';
  static const addLeaveScreen = '/add-leave';
  static const leaveSummary = "/leave-summary";
  static const leaveHistory = "/leave-history";
  static const holidays = "/holidays";
  static const updateLeavesScreen = "/update-leave";
  static const fileDownloadTest = "/file-download-test";

  //approver pages path
  static const leaveApproval = "/approval/leaves";

  static List<GetPage> routes = [
    GetPage(
        name: splashScreen,
        transition: Transition.cupertino,
        page: () => const SplashScreen()),
    GetPage(
        name: connectionScreen,
        transition: Transition.cupertino,
        page: () => const InternetConnction()),
    GetPage(
        name: loginScreen,
        transition: Transition.cupertino,
        page: () => const AuthScreen()),
    GetPage(
        name: homeScreen,
        transition: Transition.cupertino,
        page: () => LandingScreen()),
    GetPage(
      name: attdenceSubmitScreen,
      transition: Transition.cupertino,
      page: () => const AttendenceSubmitScreen(),
    ),
    GetPage(
        name: changePassword,
        transition: Transition.cupertino,
        page: () => ChangePasswordScreen()),
    GetPage(
        name: notification,
        transition: Transition.cupertino,
        page: () => NotificationScreen()),
    GetPage(
        name: profileScreen,
        transition: Transition.cupertino,
        page: () => ProfileScreen()),
    GetPage(
        name: addExpenseScreen,
        transition: Transition.cupertino,
        page: () => const AddExpenseScreen()),
    GetPage(
        name: addLeaveScreen,
        transition: Transition.cupertino,
        page: () => AddLeavesScreen()),
    GetPage(
        name: updateLeavesScreen,
        transition: Transition.cupertino,
        page: () => UpdateLeavesScreen()),
    GetPage(
        name: leaveSummary,
        transition: Transition.cupertino,
        page: () => LeaveSummaryScreen()),
    GetPage(
        name: leaveHistory,
        transition: Transition.cupertino,
        page: () => LeaveHistoryScreen()),
    GetPage(
        name: holidays,
        transition: Transition.cupertino,
        page: () => CalenderScreen()),

    // Aprroval Pages
    GetPage(
        name: leaveApproval,
        transition: Transition.cupertino,
        page: () => ApproverLeaveRequestScreen()),

    // test pages
    GetPage(
        name: fileDownloadTest,
        transition: Transition.cupertino,
        page: () => const FileDownloadTest()),
  ];
}
