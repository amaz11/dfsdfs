class ApiRoute {
  static String get baseRoot => "https://production.treal.cloud/api/v1/";
  static String loginUrl = "login";
  static String attendenceUrl = "attendances";
  static String checkInUrl = "attendance/check-in";
  static String checkOutUrl = "attendance/check-out";
  static String todayAttendenceCheckUrl = "attendance/check";
  static String sendAttendenceNote = "attendance/note";
  static String userProfile = "profile";
  static String changePassword = "profile/update-password";
  static String notifications = "notifications";
  static String companyDetails = "company-detail";
  static String leaveType = "leave-types";
  static String leaves = "leaves";
  static String holidays = "holidays";
  static String yearlyCalender = "yearly-calender";
  static String fileUpload = "upload/temp-file";
  static String leaveDaysCount = "leave-days";
  static String currentTime = "current-time";

  // Approval
  static String checkApproval = "check-approval";
  static String leaveApprovalRequest = "leave-approval-requests";
  static String approverLeaveApprovalRequest = "approver-leave-history";
}
// production
// staging

// https://production.treal.cloud/v1/public/api/

// https://staging.treal.cloud/api/v1/
