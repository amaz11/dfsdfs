import 'package:flutter/material.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/module/leaves/controller/leave_approval_controller.dart';
import 'package:trealapp/module/leaves/model/leave_approval_model.dart';
import 'package:intl/intl.dart';
import 'package:trealapp/module/leaves/view/approver/widget/approval_leave_deatails.dart';
import 'package:trealapp/module/leaves/view/approver/widget/approval_leave_footer.dart';
import 'package:trealapp/module/leaves/view/widget/leave_status_widget.dart';

class ApprovalLeaveRequestItem extends StatelessWidget {
  final Datum leave;
  final num index;
  final num leavesLastIndex;
  final LeaveApprovalController leaveController;
  final dynamic onApprove;

  const ApprovalLeaveRequestItem({
    super.key,
    required this.leave,
    required this.index,
    required this.leavesLastIndex,
    required this.leaveController,
    this.onApprove,
  });

  String formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    DateTime date = DateTime.parse(dateString);
    return DateFormat('EEE, yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 170,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              blurRadius: 5,
              color: Color.fromARGB(82, 169, 168, 168),
              offset: Offset(0, 0)),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 15),
      margin: EdgeInsets.only(
          left: 15,
          right: 15,
          top: index == 0 ? 15 : 10,
          bottom: index == leavesLastIndex ? 30 : 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            child: LeaveStatusWidget(status: leave.status ?? "N/A"),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: leave.status == "1" || leave.status == "0" ? 15 : 0),
            child: ApprovalLeaveDeatails(
                leaveController: leaveController,
                leave: leave,
                formatDate: formatDate,
                onApprove: onApprove),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10),
            child: ApprovalLeaveFooter(leave: leave),
          ),
        ],
      ),
    );
  }
}
