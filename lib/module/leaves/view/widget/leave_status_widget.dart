import 'package:flutter/widgets.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';

class LeaveStatusWidget extends StatelessWidget {
  final String status;
  const LeaveStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: status == "1"
              ? lightCyanColor2
              : status == "2"
                  ? orangeColor.withOpacity(.4)
                  : redColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
      child: Text(
        status == "1"
            ? "Approved"
            : status == "2"
                ? "Pending"
                : "Rejected",
        style: TextStyles.title11.copyWith(
          color: status == "1"
              ? cyanColor
              : status == "2"
                  ? orangeColor
                  : redColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
