import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';
import 'package:trealapp/module/attendence/controller/animation_button_contrroller.dart';
import 'package:trealapp/module/attendence/controller/attendence_report_controller.dart';
import 'package:trealapp/module/attendence/controller/location_controller.dart';
import 'package:trealapp/module/attendence/repo/attendence_report_repo.dart';
import 'package:trealapp/module/attendence/repo/attendence_submit_repo.dart';
import 'package:trealapp/module/auth/controller/auth_controller.dart';
import 'package:trealapp/module/auth/controller/drawer_controller.dart';
import 'package:trealapp/module/auth/repo/auth_repo.dart';
import 'package:trealapp/module/calender/controller/calender_controller.dart';
import 'package:trealapp/module/calender/repo/calender_repo.dart';
import 'package:trealapp/module/home/controller/landing_controller.dart';
import 'package:trealapp/module/home/repo/landing_page_repo.dart';
import 'package:trealapp/module/internet_connction_plus/controller/connection_controller.dart';
import 'package:trealapp/module/leaves/controller/add_leave_controller.dart';
import 'package:trealapp/module/leaves/controller/leave_approval_controller.dart';
import 'package:trealapp/module/leaves/controller/leave_controller.dart';
import 'package:trealapp/module/leaves/repo/add_leave_repo.dart';
import 'package:trealapp/module/leaves/repo/leave_approval_repo.dart';
import 'package:trealapp/module/notification/controller/notification_controller.dart';
import 'package:trealapp/module/notification/repo/notification_repo.dart';
import 'package:trealapp/module/profile/controller/profile_controller.dart';
import 'package:trealapp/module/setting/controller/change_password_controller.dart';
import 'package:trealapp/module/setting/repo/change_password_repo.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  //shared preference
  Get.lazyPut(() => sharedPreferences, fenix: true);

  // api client
  Get.lazyPut(
      () => ApiClient(
          appBaseUrl: ApiRoute.baseRoot, sharedPreferences: Get.find()),
      fenix: true);

  ///Repo
  // Auth-Repo
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

// Leanding Screen
  Get.lazyPut(
      () =>
          LandingPageRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  // Attendece Report
  Get.lazyPut(
      () => AttendenceReportRepo(
          apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  // Change-password
  Get.lazyPut(
      () => ChangePasswordRepo(
          apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  // Attendence-submit-repo
  Get.lazyPut(
      () => AttendenceSubmitRepo(
          apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  // Notification
  Get.lazyPut(
      () => NotificationRepo(
          apiClient: Get.find(), sharedPreferences: sharedPreferences),
      fenix: true);

  // Add Leave
  Get.lazyPut(
      () => AddLeaveRepo(
          apiClient: Get.find(), sharedPreferences: sharedPreferences),
      fenix: true);

// Holiday
  Get.lazyPut(
      () => CalenderRepo(
          apiClient: Get.find(), sharedPreferences: sharedPreferences),
      fenix: true);

  /// Approval
  // Leave
  Get.lazyPut(
      () => LeaveApprovalRepo(
          apiClient: Get.find(), sharedPreferences: sharedPreferences),
      fenix: true);

  ///
  ///Controller

  // Connection
  Get.lazyPut(() => ConnectionController());

  //Auth
  Get.lazyPut(() => AuthController(authRepo: Get.find<AuthRepo>()),
      fenix: true);

// Landing Page
  Get.lazyPut(
      () => LandingController(
          authRepo: Get.find<AuthRepo>(),
          landingPageRepo: Get.find<LandingPageRepo>()),
      fenix: true);

  // Change Password
  Get.lazyPut(
      () => ChangePasswordController(
          changePasswordRepo: Get.find<ChangePasswordRepo>()),
      fenix: true);

// Attendnce report
  Get.lazyPut(
      () => AttendenceReportController(
          attendenceReportRepo: Get.find<AttendenceReportRepo>()),
      fenix: true);

// Attendence Submit Animation button
  Get.lazyPut(
      () => AnimatedButtonController(
          attendenceSubmitRepo: Get.find<AttendenceSubmitRepo>()),
      fenix: true);

// Attendence Submit Location
  Get.lazyPut(
      () => LocationController(
          attendenceSubmitRepo: Get.find<AttendenceSubmitRepo>()),
      fenix: true);

  // Notification
  Get.lazyPut(
      () => NotificationController(
          notificationRepo: Get.find<NotificationRepo>()),
      fenix: true);

  // Profile
  Get.lazyPut(() => ProfileController(authRepo: Get.find<AuthRepo>()),
      fenix: true);

  // Add Leave
  Get.lazyPut(() => AddLeaveController(addLeaveRepo: Get.find<AddLeaveRepo>()),
      fenix: true);

  // Leave
  Get.lazyPut(() => LeaveController(addLeaveRepo: Get.find<AddLeaveRepo>()),
      fenix: true);

  // Holiday
  Get.lazyPut(() => CalenderController(holidayRepo: Get.find<CalenderRepo>()),
      fenix: true);

  // Drawer
  Get.lazyPut(() => DrawerControllerr(authRepo: Get.find<AuthRepo>()),
      fenix: true);

  /// Approval

  // Leaves
  Get.lazyPut(
      () => LeaveApprovalController(
          leaveApprovalRepo: Get.find<LeaveApprovalRepo>()),
      fenix: true);
}

class AttendanceSubmitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
  }
}
