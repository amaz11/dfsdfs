import 'package:flutter/material.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/module/leaves/model/leave_model.dart';

class LeaveFooterWidget extends StatelessWidget {
  final Leaves leave;

  const LeaveFooterWidget({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 219, 219, 219), width: 1))),
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: lightGrayColor2.withOpacity(0.2),
            ),
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    size: 16, color: grayColor),
                const SizedBox(width: 5),
                Text(leave.leaveApplyDate ?? "N/A",
                    style: TextStyles.title12.copyWith(color: grayColor))
              ],
            ),
          ),
          const SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: blueColor.withOpacity(0.1),
            ),
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Text(leave.leaveTypeName ?? "N/A",
                style: TextStyles.title12
                    .copyWith(color: blueColor.withOpacity(0.8))),
          ),
        ],
      ),
    );
  }
}
