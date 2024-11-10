import 'package:flutter/material.dart';

// import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';

import 'package:trealapp/module/dashboard/view/widget/attendence.dart';
import 'package:trealapp/module/dashboard/view/widget/ex_sc_le.dart';
import 'package:trealapp/module/dashboard/view/widget/tasks.dart';

class DashboardSrceen extends StatelessWidget {
  const DashboardSrceen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          padding:
              const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AttendenceWidget(),
                const SizedBoxHight(
                  hieght: 16,
                ),
                const TasksWidget(),
                const SizedBoxHight(
                  hieght: 16,
                ),
                ExScLe(),
                const SizedBoxHight(
                  hieght: 16,
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       // DialogUtils().infoSnackbar("This Error Message");
                //       Get.toNamed(AppRoutes.leaveApproval);
                //     },
                //     child: const Text("Leave Approval"))
              ],
            ),
          )),
    );
  }
}
