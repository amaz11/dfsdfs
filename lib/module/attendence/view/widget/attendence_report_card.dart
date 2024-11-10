import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';

class AttendanceReportCard extends StatelessWidget {
  final String dayMonthShort;
  final String dayAbbreviation;
  final String checkInTime;
  final String checkOutTime;
  final String totalHours;
  final bool isLate;
  final int index;
  final int length;

  const AttendanceReportCard({
    super.key,
    required this.dayMonthShort,
    required this.dayAbbreviation,
    required this.checkInTime,
    required this.checkOutTime,
    required this.totalHours,
    required this.isLate,
    required this.index,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.height85,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.20,
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: EdgeInsets.all(Dimensions.padding08),
      margin: EdgeInsets.only(
        bottom: index == length - 1 ? Dimensions.margin20 : Dimensions.margin15,
        top: index == 0 ? Dimensions.margin15 : 0,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _dateBox(dayMonthShort, dayAbbreviation)),
                SizedBox(width: Dimensions.padding15),
                Expanded(
                    child:
                        _checkInBox(checkInTime: checkInTime, isLate: isLate)),
                SizedBox(width: Dimensions.padding15),
                Expanded(child: _checkOutBox(checkOutTime: checkOutTime)),
                SizedBox(width: Dimensions.padding15),
                Expanded(child: _totalHoursBox(totalHours: totalHours)),
                SizedBox(width: Dimensions.padding15),
                Expanded(child: _checkInStatusBox(isLate: isLate)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateBox(String dayMonthShort, String dayAbbreviation) {
    return Container(
      width: Dimensions.width60,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimensions.radius8),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffbebebe),
            offset: Offset(-5, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xffffffff),
            offset: Offset(-5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(Dimensions.padding08),
      child: Column(
        children: [
          Text(
            dayMonthShort,
            style: TextStyles.title16.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            dayAbbreviation,
            style: TextStyles.regular14.copyWith(
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkInBox({required String checkInTime, required bool isLate}) {
    return Column(
      children: [
        Icon(
          Icons.more_time_outlined,
          color: isLate ? redColor : cyanColor,
          size: Dimensions.icon24,
        ),
        const SizedBoxHight(hieght: 5),
        Text(
          checkInTime,
          style: TextStyles.title11,
        ),
        Text(
          "Check In",
          style: TextStyles.regular10
              .copyWith(color: lightGrayColor, fontSize: Dimensions.font10),
        ),
      ],
    );
  }

  Widget _checkOutBox({required String checkOutTime}) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.minus_circle,
          color: redColor,
          size: Dimensions.icon24,
        ),
        const SizedBoxHight(hieght: 5),
        Text(
          checkOutTime,
          style: TextStyles.title11,
        ),
        Text(
          "Check Out",
          style: TextStyles.regular10
              .copyWith(color: lightGrayColor, fontSize: Dimensions.font10),
        ),
      ],
    );
  }

  Widget _totalHoursBox({required String totalHours}) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.check_mark_circled,
          color: blueColor,
          size: Dimensions.icon24,
        ),
        const SizedBoxHight(hieght: 5),
        Text(
          totalHours,
          style: TextStyles.title11,
        ),
        Text(
          'Total Hrs',
          style: TextStyles.regular10
              .copyWith(color: lightGrayColor, fontSize: Dimensions.font10),
        ),
      ],
    );
  }

  Widget _checkInStatusBox({required bool isLate}) {
    return Column(
      children: [
        Icon(
          isLate
              ? CupertinoIcons.exclamationmark_triangle
              : CupertinoIcons.check_mark_circled,
          color: isLate ? redColor : cyanColor,
          size: Dimensions.icon24,
        ),
        const SizedBoxHight(hieght: 5),
        Expanded(
          child: Text(
            isLate ? "Late" : "On time",
            style: TextStyles.title11,
          ),
        ),
        Expanded(
          child: Text(
            'Status',
            overflow: TextOverflow.ellipsis,
            // maxLines: 1,
            style: TextStyles.regular10.copyWith(
              color: lightGrayColor,
            ),
          ),
        ),
      ],
    );
  }
}
