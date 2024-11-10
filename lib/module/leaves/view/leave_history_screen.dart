import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/leaves/controller/leave_controller.dart';
import 'package:trealapp/module/leaves/model/leave_model.dart';
import 'package:trealapp/module/leaves/view/widget/leave_history_item.dart';
import 'dart:math' as math;

class LeaveHistoryScreen extends StatelessWidget {
  LeaveHistoryScreen({super.key});
  final LeaveController leaveController = Get.find<LeaveController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave History", style: TextStyles.title16),
        shadowColor: Colors.black26,
        backgroundColor: whiteColor,
        toolbarHeight: 50,
        actions: [
          GestureDetector(
              onTap: () {
                leaveController.toggleSearch();
              },
              child: const Icon(Icons.tune)),
          const SizedBox(
            width: 10,
          )
        ],
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(80.0),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Obx(() => AnimatedContainer(
        //             duration: const Duration(
        //                 milliseconds:
        //                     300), // Adjust duration for smoother transition
        //             height: leaveController.searchToggle.value ? 30.0 : 0.0,
        //             child: leaveController.searchToggle.value
        //                 ? Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       _buildNavButton(
        //                         icon: Icons.arrow_back_ios,
        //                         onPressed: leaveController.previousYear,
        //                       ),
        //                       _buildYearDisplay(),
        //                       _buildNavButton(
        //                         icon: Icons.arrow_forward_ios,
        //                         onPressed: leaveController.nextYear,
        //                       ),
        //                     ],
        //                   )
        //                 : const SizedBox(),
        //           )),
        //       TabBar(
        //         controller: leaveController.tabController,
        //         isScrollable: true,
        //         automaticIndicatorColorAdjustment: false,
        //         indicatorColor: Colors.blue, // Customize indicator color
        //         labelColor: Colors.black, // Selected tab text color
        //         unselectedLabelColor: Colors.grey, // Unselected tab text color
        //         // labelPadding: EdgeInsets.only(left: 15, right: 15),
        //         tabAlignment: TabAlignment.center,
        //         tabs: [
        //           Tab(
        //             child: Text(
        //               "All",
        //               style: TextStyles.title16,
        //             ),
        //           ),
        //           Tab(child: Text("Pending", style: TextStyles.title16)),
        //           Tab(child: Text("Accepted", style: TextStyles.title16)),
        //           Tab(child: Text("Rejected", style: TextStyles.title16)),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ),
      body: RefreshIndicator(
          onRefresh: leaveController.refreshgetAllLeaveMethod,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              Obx(
                () => SliverAppBar(
                  automaticallyImplyLeading: false,
                  surfaceTintColor: whiteColor,
                  shadowColor: whiteColor,
                  backgroundColor: whiteColor,
                  floating: true,
                  expandedHeight: leaveController.expandedHeight.value,
                  pinned: true,
                  flexibleSpace: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(
                            milliseconds:
                                300), // Adjust duration for smoother transition
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
                      ),
                      TabBar(
                        controller: leaveController.tabController,
                        isScrollable: true,
                        automaticIndicatorColorAdjustment: false,
                        dividerColor: Colors.transparent,
                        indicatorColor:
                            Colors.blue, // Customize indicator color
                        labelColor: Colors.black, // Selected tab text color
                        unselectedLabelColor:
                            Colors.grey, // Unselected tab text color
                        // labelPadding: EdgeInsets.only(left: 15, right: 15),
                        // overlayColor: Colors.transparent,
                        tabAlignment: TabAlignment.center,
                        tabs: [
                          Tab(
                            child: Text(
                              "All",
                              style: TextStyles.title16,
                            ),
                          ),
                          Tab(
                              child:
                                  Text("Pending", style: TextStyles.title16)),
                          Tab(
                              child:
                                  Text("Accepted", style: TextStyles.title16)),
                          Tab(
                              child:
                                  Text("Rejected", style: TextStyles.title16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                  child: TabBarView(
                controller: leaveController.tabController,
                children: [
                  _buildLeaveList(leaveController.leaveHistory), // All
                  _buildLeaveList(leaveController.leaveHistory), // Pending
                  _buildLeaveList(leaveController.leaveHistory), // Accepted
                  _buildLeaveList(leaveController.leaveHistory), // Rejected
                ],
              )),
            ],
          )),
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

  /// Builds a ListView of leave items with animation.
  Widget _buildLeaveList(List<Leaves> leaveList) {
    return Obx(() {
      if (leaveController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (leaveList.isEmpty) {
        return const Center(
          child: Text(
            "No leave history available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      } else {
        return RefreshIndicator(
          onRefresh: leaveController.refreshgetAllLeaveMethod,
          child: AnimatedList(
            physics: const AlwaysScrollableScrollPhysics(), // Ensure scrolling
            initialItemCount: leaveList.length,
            itemBuilder: (context, index, animation) {
              final leave = leaveList[index];
              return FadeTransition(
                opacity: animation,
                child: LeaveHistoryItem(
                  leave: leave,
                  index: index,
                  leavesLastIndex: leaveList.length - 1,
                  leaveController: leaveController,
                  onDelete: () async {
                    leaveController.deleteLeave(
                      context,
                      index,
                      leave.id!,
                      leave,
                      leaveList,
                    );
                  },
                ),
              );
            },
          ),
        );
      }
    });
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
