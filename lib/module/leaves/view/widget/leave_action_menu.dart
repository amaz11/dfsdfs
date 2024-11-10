import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/leaves/controller/leave_controller.dart';
import 'package:trealapp/module/leaves/model/leave_model.dart';

class LeaveActionMenu extends StatelessWidget {
  final Leaves leave;
  final LeaveController leaveController;
  final VoidCallback onDelete; // Add this callback for the delete action
  const LeaveActionMenu({
    super.key,
    required this.leave,
    required this.leaveController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: whiteColor,
      icon: const Icon(Icons.more_horiz, size: 22),
      onSelected: (int selectedValue) {
        if (selectedValue == 1) {
          Get.toNamed(
            AppRoutes.updateLeavesScreen,
            arguments: {
              "leaveTypeId": leave.leaveTypeId,
              "fromDate": leave.fromDate,
              "toDate": leave.toDate,
              "reason": leave.reason,
              "isHalfDay": leave.isHalfDay,
              "leaveId": leave.id,
            },
          );
        } else if (selectedValue == 2) {
          DialogUtils().showDeleteConfirmationDialog(
            title: "Delete Item",
            content: "Are you sure you want to delete this item?",
            onConfirm: () {
              onDelete(); // Trigger the fade-out animation and deletion
              Get.back();
            },
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.edit, size: 16, color: cyanColor),
              const SizedBox(width: 8),
              Text('Update', style: TextStyles.title12),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 16, color: redColor),
              const SizedBox(width: 8),
              Text('Delete', style: TextStyles.title12),
            ],
          ),
        ),
      ],
    );
  }
}
