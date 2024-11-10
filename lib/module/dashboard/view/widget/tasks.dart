import 'package:flutter/material.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';

class TasksWidget extends StatelessWidget {
  const TasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.20,
              blurRadius: 3,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_teaskActivity(context), _headLine()],
      ),
    );
  }

  Widget _teaskActivity(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusBar(),
        const SizedBoxHight(),
        _rowStatusDetailsTop(context),
        const SizedBoxHight(),
        _rowStatusDetailsBottom(context)
      ],
    );
  }

  Widget _statusBar() {
    return Row(
      children: [
        _statusBarItem(cyanColor, "All"),
        const SizedBox(
          width: 10,
        ),
        _statusBarItem(orangeColor, "New"),
        const SizedBox(
          width: 10,
        ),
        _statusBarItem(lightRedColor, "In Progress"),
        const SizedBox(
          width: 10,
        ),
        _statusBarItem(lightVioletColor, "Complete")
      ],
    );
  }

  Widget _statusBarItem(Color color, String name) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          width: 16,
          height: 16,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          name,
          style: TextStyles.regular10
              .copyWith(color: color, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  // Widget _gridView(BuildContext context) {
  //   return SizedBox(
  //     height: 100,
  //     child: GridView.count(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 10,
  //       mainAxisSpacing: 10,
  //       shrinkWrap: true,
  //       children: List.generate(4, (index) {
  //         return _statusDetails(
  //             context, Icons.fiber_new_rounded, "0", lightVioletColor);
  //       }),
  //     ),
  //   );
  // }

  Widget _rowStatusDetailsTop(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statusDetails(context, Icons.fiber_new_rounded, "0", cyanColor),
        const SizedBox(
          width: 10,
        ),
        _statusDetails(context, Icons.access_time_rounded, "0", orangeColor),
      ],
    );
  }

  Widget _rowStatusDetailsBottom(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statusDetails(context, Icons.bar_chart_rounded, "0", lightRedColor),
        const SizedBox(
          width: 10,
        ),
        _statusDetails(context, Icons.timer_outlined, "0", lightVioletColor),
      ],
    );
  }

  Widget _statusDetails(
      BuildContext context, IconData icon, String count, Color color) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * .38,
      decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.20,
              blurRadius: 2,
              offset: const Offset(2, 0), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: whiteColor,
            size: 28,
          ),
          Text(
            count,
            style: TextStyles.title22.copyWith(color: whiteColor),
          )
        ],
      ),
    );
  }

  Widget _headLine() {
    return Container(
      decoration: const BoxDecoration(
          color: lightCyanColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
      padding: const EdgeInsets.only(right: 12, left: 20, top: 20, bottom: 20),
      child: Column(
        children: [
          Text(
            "T",
            style: TextStyles.title18,
          ),
          Text(
            "A",
            style: TextStyles.title18,
          ),
          Text(
            "S",
            style: TextStyles.title18,
          ),
          Text(
            "K",
            style: TextStyles.title18,
          ),
          Text(
            "S",
            style: TextStyles.title18,
          )
        ],
      ),
    );
  }
}
