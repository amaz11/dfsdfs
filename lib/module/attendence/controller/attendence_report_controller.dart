import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/attendence/model/attendence_report_model.dart';
import 'package:trealapp/module/attendence/repo/attendence_report_repo.dart';
import 'package:intl/intl.dart';

class AttendenceReportController extends GetxController {
  AttendenceReportRepo? attendenceReportRepo;
  AttendenceReportController({this.attendenceReportRepo});

  final RxString page = "1".obs;
  final RxString startDate = "".obs;
  final RxString endDate = "".obs;
  final RxString perPage = "20".obs;
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;

  ScrollController scrollController = ScrollController();

  // text controller
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();
  // Attendance Reports Data
  var attendanceReports = <AttendanceData>[].obs;
  var isLoading = false.obs;

  // current Date
  var currentDate = DateTime.now().obs;

  // Format date as 'MMMM yyyy'
  String get formattedDate => DateFormat('MMMM yyyy').format(currentDate.value);
  late AttendanceReportModel attendanceReportModel;

  @override
  void onInit() {
    super.onInit();
    getCurrentMonthUserAttendenceReports();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isBottom = scrollController.position.pixels ==
            scrollController.position.maxScrollExtent;

        if (isBottom) {
          if (page.value !=
              attendanceReportModel.pagination!.lastPage.toString()) {
            page.value = (int.parse(page.value) + 1).toString();
            // TODO: Infinit Scroll Pagination
            // print('Fetching page ${page.value}');
            getSearchAttendenceReports(loadMore: true);
          } else {
            // print('No more pages to load');
            getSearchAttendenceReports(loadMore: false);
          }
        }
      }
    });
  }

  Future selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await datePicker(context);
    if (pickedDate != null && pickedDate != fromDate.value) {
      fromDate.value = pickedDate;
      fromDateController.text = DateFormat('yyyy-MM-dd').format(fromDate.value);
      update();
    }
  }

  Future selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await datePicker(context);
    if (pickedDate != null && pickedDate != toDate.value) {
      toDate.value = pickedDate;
      toDateController.text = DateFormat('yyyy-MM-dd').format(toDate.value);
      update();
    }
  }

  Future datePicker(context) async {
    DateTime selectedDate = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(selectedDate.year - 100),
      lastDate: DateTime(selectedDate.year + 100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: blueColor,
              onPrimary: Colors.white,
              surface: whiteColor,
              onSurface: grayColor,
            ),
            dialogBackgroundColor: Colors.blue[900],
          ),
          child: child!,
        );
      },
    );
  }

  // Go to the previous month
  void previousMonth() async {
    currentDate.value =
        DateTime(currentDate.value.year, currentDate.value.month - 1);

    getFistLastDateOfMonth(currentDate.value);
    await getUserAttendenceReports();
  }

  // Go to the next month
  void nextMonth() async {
    currentDate.value =
        DateTime(currentDate.value.year, currentDate.value.month + 1);
    getFistLastDateOfMonth(currentDate.value);
    await getUserAttendenceReports();
  }

  void getFistLastDateOfMonth(DateTime date) {
    DateTime firstDateOfMonth = DateTime(date.year, date.month, 1);
    String formattedFirstDateOfMonth =
        DateFormat('yyyy-MM-dd').format(firstDateOfMonth);

// Get the last date of the current month
    DateTime lastDateOfMonth = DateTime(date.year, date.month + 1, 0);
    String formattedLastDateOfMonth =
        DateFormat('yyyy-MM-dd').format(lastDateOfMonth);
    startDate.value = formattedFirstDateOfMonth;
    endDate.value = formattedLastDateOfMonth;
    update();
  }

  getCurrentMonthUserAttendenceReports() async {
    getFistLastDateOfMonth(currentDate.value);
    await getUserAttendenceReports();
  }

// Methods
  Future<void> getUserAttendenceReports() async {
    try {
      isLoading(true);
      Response response = await attendenceReportRepo!.getAttendenceReport(
        page.value,
        perPage.value,
        startDate.value,
        endDate.value,
      );
      if (response.statusCode == 200) {
        attendanceReportModel = AttendanceReportModel.fromJson(response.body);
        if (attendanceReportModel.data != null) {
          attendanceReports.value = attendanceReportModel.data!;
          update();
        }
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getSearchAttendenceReports({bool loadMore = false}) async {
    startDate.value = fromDateController.text;
    endDate.value = toDateController.text;
    try {
      if (!loadMore) {
        page.value = "1"; // Reset page when new search is initiated
      }

      if (fromDateController.text.isNotEmpty &&
          toDateController.text.isNotEmpty) {
        startDate.value = fromDateController.text;
        endDate.value = toDateController.text;
      } else {
        getFistLastDateOfMonth(currentDate.value);
      }

      Response response = await attendenceReportRepo!.getAttendenceReport(
        page.value,
        perPage.value,
        startDate.value,
        endDate.value,
      );

      if (response.statusCode == 200) {
        AttendanceReportModel attendanceReportModel =
            AttendanceReportModel.fromJson(response.body);

        if (attendanceReportModel.data != null) {
          if (loadMore) {
            // Append data for pagination
            attendanceReports.addAll(attendanceReportModel.data!);
          } else {
            // Replace data for new search
            attendanceReports.value = attendanceReportModel.data!;
            fromDateController.text;
            toDateController.text;
          }
          update();
        }
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e.toString());
    } finally {
      isLoading(false);
      fromDateController.text;
      toDateController.text;
    }
  }

  Future<void> refreshUserAttendenceRepost() async {
    startDate.value = "";
    endDate.value = "";
    currentDate.value = DateTime.now();
    await getUserAttendenceReports();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
