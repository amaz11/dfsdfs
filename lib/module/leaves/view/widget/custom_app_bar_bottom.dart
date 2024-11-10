import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/leaves/controller/leave_controller.dart';
import 'dart:math' as math;

class CustomAppBarBottom extends StatelessWidget
    implements PreferredSizeWidget {
  final LeaveController leaveController;

  const CustomAppBarBottom({super.key, required this.leaveController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: leaveController.searchToggle.value ? 40.0 : 0.0,
              child: leaveController.searchToggle.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildNavButton(
                          icon: Icons.arrow_back_ios,
                          onPressed: leaveController.previousYear,
                        ),
                        _buildYearDisplay(),
                        _buildNavButton(
                          icon: Icons.arrow_forward_ios,
                          onPressed: leaveController.nextYear,
                        ),
                      ],
                    )
                  : const SizedBox(),
            )),
        TabBar(
          controller: leaveController.tabController,
          isScrollable: true,
          automaticIndicatorColorAdjustment: false,
          indicatorColor: Colors.blue,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(child: Text("All", style: TextStyles.title16)),
            Tab(child: Text("Pending", style: TextStyles.title16)),
            Tab(child: Text("Accepted", style: TextStyles.title16)),
            Tab(child: Text("Rejected", style: TextStyles.title16)),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => (Size.fromHeight(
        leaveController.searchToggle.value ? 80.0 : 50.0,
      ));

  // Navigation Buttons for Previous/Next Month
  IconButton _buildNavButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, size: 20, color: lightGrayColor),
      onPressed: onPressed,
    );
  }

  // Month Display with Calendar Search Bottom Sheet
  SizedBox _buildYearDisplay() {
    return SizedBox(
      width: Dimensions.width135,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Text(
              "${leaveController.currentDate.value.year}",
              style: TextStyles.regular16.copyWith(
                color: lightGrayColor,
                fontWeight: FontWeight.w600,
              ),
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
                  controller: leaveController.fromDateController,
                  onTap: () {
                    leaveController.dateRangePicker();
                  }
                  // attendenceReportController.selectStartDate(Get.context!),
                  ),
              const SizedBoxHight(hieght: 15),
              _buildDatePickerField(
                  hint: "Select To Date",
                  controller: leaveController.toDateController,
                  onTap: () {
                    leaveController.dateRangePicker();
                  }
                  // attendenceReportController.selectEndDate(Get.context!),
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
          leaveController.dateRangeSearch();

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
}
