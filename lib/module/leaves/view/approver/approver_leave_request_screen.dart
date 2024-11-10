import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/module/leaves/controller/leave_approval_controller.dart';
// import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/module/leaves/model/leave_approval_model.dart';
import 'package:trealapp/module/leaves/view/approver/widget/approval_leave_request_item.dart';

class ApproverLeaveRequestScreen extends StatelessWidget {
  ApproverLeaveRequestScreen({super.key});

  final LeaveApprovalController leaveApprovalController =
      Get.find<LeaveApprovalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        // title: Text("Leaves Request", style: TextStyles.title16),
        // shadowColor: Colors.black26,
        backgroundColor: Colors.white,

        bottom: TabBar(
          controller: leaveApprovalController.tabController,
          indicatorColor: Colors.blue, // Customize indicator color
          labelColor: Colors.black, // Selected tab text color
          unselectedLabelColor: Colors.grey, // Unselected tab text color
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(
              child: Text("Pending", style: TextStyles.title16),
            ),
            Tab(child: Text("Overview", style: TextStyles.title16)),
            Tab(child: Text("Accepted by me", style: TextStyles.title16)),
            Tab(child: Text("Rejected by me", style: TextStyles.title16)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TabBarView(
          controller: leaveApprovalController.tabController,
          children: [
            _buildTabContent(
                leaveApprovalController.leaveApprovalRequestData), // Pending
            _buildTabContent(
                leaveApprovalController.leaveApprovalRequestData), // Overview
            _buildTabContent(
                leaveApprovalController.leaveApprovalRequestData), // Accepted
            _buildTabContent(
                leaveApprovalController.leaveApprovalRequestData), // Rejected
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(List<Datum> leaveList) {
    return RefreshIndicator(
      onRefresh: leaveApprovalController.refreshgetAllApproverLeaveMethod,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          _buildLeaveList(leaveList),
        ],
      ),
    );
  }

  /// Builds a ListView of leave items with animation.
  SliverFillRemaining _buildLeaveList(List<Datum> leaveList) {
    return SliverFillRemaining(
        hasScrollBody: true,
        child: Obx(() {
          if (leaveApprovalController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (leaveList.isEmpty) {
            return const Center(
              child: Text(
                "No Approval leave history available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh:
                  leaveApprovalController.refreshgetAllApproverLeaveMethod,
              child: AnimatedList(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Ensure scrolling
                initialItemCount: leaveList.length,
                itemBuilder: (context, index, animation) {
                  final leave = leaveList[index];
                  return FadeTransition(
                    opacity: animation,
                    child: ApprovalLeaveRequestItem(
                      leave: leave,
                      index: index,
                      leavesLastIndex: leaveList.length - 1,
                      leaveController: leaveApprovalController,
                      onApprove: (int approve, String? note) async {
                        leaveApprovalController
                            .removeFromPendindTabApproveLeave(
                                context, index, leave.id!, approve, note);
                      },
                    ),
                  );
                },
              ),
            );
          }
        }));
  }
}
