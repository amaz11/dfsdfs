import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/attendence/controller/attendence_report_controller.dart';
import 'package:trealapp/module/attendence/view/widget/attendence_report_card.dart';

class AttendenceReportScreen extends StatelessWidget {
  AttendenceReportScreen({super.key});

  final AttendenceReportController attendenceReportController =
      Get.find<AttendenceReportController>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          color: blueColor,
          onRefresh: attendenceReportController.refreshUserAttendenceRepost,
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              _buildReportContent(context),
            ],
          ),
        );
      },
    );
  }

  // Sliver AppBar with Month Navigation and Calendar Search
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      surfaceTintColor: whiteColor,
      shadowColor: whiteColor,
      pinned: true,
      flexibleSpace: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          height: Dimensions.height40,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: attendenceReportController.previousMonth,
                ),
                _buildMonthDisplay(),
                _buildNavButton(
                  icon: Icons.arrow_forward_ios,
                  onPressed: attendenceReportController.nextMonth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Navigation Buttons for Previous/Next Month
  IconButton _buildNavButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, size: 20, color: lightGrayColor),
      onPressed: onPressed,
    );
  }

  // Month Display with Calendar Search Bottom Sheet
  SizedBox _buildMonthDisplay() {
    return SizedBox(
      width: Dimensions.width170,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            attendenceReportController.formattedDate,
            style: TextStyles.regular16.copyWith(
              color: lightGrayColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: _showCalendarBottomSheet,
            child: const Icon(
              Icons.calendar_month_outlined,
              size: 20,
              color: lightGrayColor,
            ),
          ),
        ],
      ),
    );
  }

  // Calendar Bottom Sheet for Date Range Search
  void _showCalendarBottomSheet() {
    Get.bottomSheet(
      Material(
        color: Colors.transparent,
        child: Container(
          height: Dimensions.height240,
          padding: EdgeInsets.all(Dimensions.padding20),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Dimensions.radius20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search For Attendance",
                style: TextStyles.regular12.copyWith(
                  fontWeight: FontWeight.w600,
                  color: grayColor,
                ),
              ),
              const SizedBoxHight(),
              _buildDatePickerField(
                hint: "Select From Date",
                controller: attendenceReportController.fromDateController,
                onTap: () =>
                    attendenceReportController.selectStartDate(Get.context!),
              ),
              const SizedBoxHight(hieght: 15),
              _buildDatePickerField(
                hint: "Select To Date",
                controller: attendenceReportController.toDateController,
                onTap: () =>
                    attendenceReportController.selectEndDate(Get.context!),
              ),
              const SizedBoxHight(),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildSearchButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Date Picker TextField
  TextField _buildDatePickerField({
    required String hint,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: lightGrayColor2),
        prefixIcon: const Icon(Icons.calendar_month_outlined),
      ),
    );
  }

  // Search Button inside Bottom Sheet
  Align _buildSearchButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          attendenceReportController.getSearchAttendenceReports();
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        ),
        child: Row(
          children: [
            Transform.rotate(
              angle: 90 * math.pi / 180,
              child: const Icon(Icons.search, color: whiteColor),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Search",
              style: TextStyles.regular16.copyWith(color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }

  // Main Content displaying the Reports
  SliverFillRemaining _buildReportContent(BuildContext context) {
    return SliverFillRemaining(
      child: Obx(() {
        if (attendenceReportController.isLoading.value) {
          return _buildLoadingIndicator(context);
        }
        if (attendenceReportController.attendanceReports.isEmpty) {
          return _buildNoReportsMessage();
        }
        return RefreshIndicator(
            color: blueColor,
            onRefresh: attendenceReportController.refreshUserAttendenceRepost,
            child: _buildReportsList());
      }),
    );
  }

  // Loading Indicator
  Center _buildLoadingIndicator(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: blueColor),
    );
  }

  // Message when no reports are found
  Center _buildNoReportsMessage() {
    return Center(
      child: Text(
        'No reports found!',
        style: TextStyles.title16.copyWith(color: lightGrayColor),
      ),
    );
  }

  // List of Attendance Reports
  ListView _buildReportsList() {
    return ListView.builder(
      controller: attendenceReportController.scrollController,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.padding08),
      itemCount: attendenceReportController.attendanceReports.length,
      itemBuilder: (context, index) {
        var report = attendenceReportController.attendanceReports[index];
        return _buildReportCard(report, index);
      },
    );
  }

  // Single Attendance Report Card
  AttendanceReportCard _buildReportCard(report, int index) {
    bool isLate = report.isLate == "1";
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(report.date!);
    String date = DateFormat('EEE, dd MMM yy').format(dateTime);
    String checkInTime = _formatTime(report.checkInTime);
    String checkOutTime =
        report.checkOutTime == null ? "N/A" : _formatTime(report.checkOutTime);
    String totalHours =
        report.checkOutTime == null ? "N/A" : _calculateTotalHours(report);

    return AttendanceReportCard(
      dayMonthShort: date.split(', ')[1].split(' ')[0],
      dayAbbreviation: date.split(', ')[0],
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      totalHours: totalHours,
      isLate: isLate,
      index: index,
      length: attendenceReportController.attendanceReports.length,
    );
  }

  // Helper function to format time
  String _formatTime(String? time) {
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time!);
    return DateFormat("hh:mm a").format(dateTime);
  }

  // Calculate total working hours
  String _calculateTotalHours(report) {
    DateTime checkIn = DateFormat("HH:mm:ss").parse(report.checkInTime!);
    DateTime checkOut = DateFormat("HH:mm:ss").parse(report.checkOutTime!);
    Duration difference = checkOut.difference(checkIn);
    return "${difference.inHours}h ${difference.inMinutes.remainder(60)}m";
  }
}
