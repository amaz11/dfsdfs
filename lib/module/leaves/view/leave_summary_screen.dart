import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/leaves/controller/leave_controller.dart';

class LeaveSummaryScreen extends StatelessWidget {
  LeaveSummaryScreen({super.key});
  final LeaveController leaveController = Get.find<LeaveController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave Summary",
          style: TextStyles.title16.copyWith(color: grayColor),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu), // You can change this to any other icon
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(Dimensions.padding15),
        child: RefreshIndicator(
          onRefresh: leaveController.refreshgetAllLeaveMethod,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: Column(
                  children: [
                    _buildLeaveSummaryBox(context),
                    SizedBoxHight(hieght: Dimensions.height20),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveSummaryBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        color: whiteColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color.fromARGB(82, 169, 168, 168),
            offset: Offset(0, 5),
          )
        ],
      ),
      padding: EdgeInsets.all(Dimensions.padding08),
      child: Column(
        children: [
          Text("Leave Summary", style: TextStyles.title18),
          SizedBoxHight(hieght: Dimensions.height20),
          // _buildLeaveSummaryStatistics(),
          // const SizedBoxHight(hieght: 20),
          _buildLeaveTypeList(),
        ],
      ),
    );
  }

  // Widget _buildLeaveSummaryStatistics() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(color: blueColor.withOpacity(0.1)),
  //       borderRadius: BorderRadius.circular(Dimensions.radius8),
  //     ),
  //     padding: const EdgeInsets.all(0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         _buildSummaryColumn("Balance", "16"),
  //         _buildSummaryColumn("Used", "16", withBorders: true),
  //         _buildSummaryColumn("Entitlement", "16"),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildSummaryColumn(String title, String value,
  //     {bool withBorders = false}) {
  //   return Expanded(
  //     child: Container(
  //       padding: EdgeInsets.symmetric(vertical: Dimensions.padding05),
  //       decoration: withBorders
  //           ? BoxDecoration(
  //               border: Border(
  //                 right: BorderSide(color: blueColor.withOpacity(0.1)),
  //                 left: BorderSide(color: blueColor.withOpacity(0.1)),
  //               ),
  //             )
  //           : null,
  //       child: Column(
  //         children: [
  //           Text(title, style: TextStyles.title12),
  //           SizedBoxHight(hieght: Dimensions.height5),
  //           Text(value, style: TextStyles.regular12),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLeaveTypeList() {
    return Container(
      padding: EdgeInsets.only(
          left: Dimensions.padding08,
          right: Dimensions.padding08,
          top: Dimensions.padding10,
          bottom: Dimensions.padding05),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildListHeader("Leave type"),
              _buildListHeader("Entitlement"),
              _buildListHeader("Used days"),
              _buildListHeader("Remaining"),
            ],
          ),
          SizedBoxHight(hieght: Dimensions.height15),
          _buildLeaveSummaryContent(),
        ],
      ),
    );
  }

  Widget _buildListHeader(String title) {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: TextStyles.title12,
        ),
      ),
    );
  }

  Widget _buildLeaveSummaryContent() {
    return Obx(() {
      if (leaveController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (leaveController.leaveSummary.isEmpty) {
        return Center(
          child: Text(
            'No reports found!',
            style: TextStyles.title16.copyWith(color: lightGrayColor),
          ),
        );
      }

      return Column(
        children: leaveController.leaveSummary.map((summary) {
          return _buildLeaveSummaryRow(summary);
        }).toList(),
      );
    });
  }

  Widget _buildLeaveSummaryRow(var summary) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(43, 169, 168, 168)),
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 0,
            color: Color.fromARGB(82, 169, 168, 168),
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: EdgeInsets.all(Dimensions.padding08),
      margin: EdgeInsets.only(bottom: Dimensions.margin15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryRowData(summary.leaveType ?? "N/A"),
          _buildSummaryRowData(summary.totalEntitlement?.toString() ?? "0"),
          _buildSummaryRowData(summary.usedDays?.toString() ?? "0"),
          _buildSummaryRowData(summary.remainingDays?.toString() ?? "0"),
        ],
      ),
    );
  }

  Widget _buildSummaryRowData(String data) {
    return Expanded(
      child: Center(
        child: Text(data, style: TextStyles.title11),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          text: "Leave History",
          onPressed: () {
            Get.toNamed(AppRoutes.leaveHistory);
          },
        ),
        _buildActionButton(
          text: "Apply Leave",
          onPressed: () {
            Get.toNamed(AppRoutes.addLeaveScreen);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      {required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: blueColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: const Size(100, 40),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyles.regular14.copyWith(color: whiteColor),
      ),
    );
  }
}
