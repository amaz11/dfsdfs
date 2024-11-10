import 'package:flutter/material.dart';

import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/module/leaves/controller/leave_controller.dart';
import 'package:trealapp/module/leaves/model/leave_model.dart';

class ApproverActionMenu extends StatelessWidget {
  final Leaves leave;
  final LeaveController leaveController;
  final VoidCallback onDelete; // Add this callback for the delete action
  const ApproverActionMenu({
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
          return;
        } else if (selectedValue == 2) {
          return;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.edit, size: 16, color: cyanColor),
              const SizedBox(width: 8),
              Text('Pending', style: TextStyles.title12),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 16, color: redColor),
              const SizedBox(width: 8),
              Text('Rejected', style: TextStyles.title12),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 16, color: redColor),
              const SizedBox(width: 8),
              Text('Accepte', style: TextStyles.title12),
            ],
          ),
        ),
      ],
    );
  }
}
