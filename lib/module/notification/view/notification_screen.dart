import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/module/notification/controller/notification_controller.dart';
import 'package:trealapp/module/notification/view/widget/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final NotificationController notificationController =
      Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Your notifications",
              style: TextStyles.title16.copyWith(color: grayColor),
            ),
            shadowColor: Colors.black26,
            backgroundColor: Colors.white,
            bottom: TabBar(
                indicatorColor: blueColor,
                controller: notificationController.tabController,
                tabs: const [
                  Tab(
                    text: "All",
                  ),
                  Tab(
                    text: "Read",
                  ),
                  Tab(
                    text: "Unread",
                  ),
                ]),
          ),
          body: TabBarView(
              controller: notificationController.tabController,
              children: [
                NotificationItem(
                    notificationController: notificationController),
                NotificationItem(
                    notificationController: notificationController),
                NotificationItem(
                    notificationController: notificationController),
              ]),
        ),
      ),
    );
  }
}

// Column(
//             children: [
//  Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: lightGrayColor2.withOpacity(0.15),
//                 ),
//                 padding:
//                     const EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 8),
//                 margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         notificationController.changeNotificationStatus("all");
//                       },
//                       child: Obx(() {
//                         return Container(
//                             decoration: BoxDecoration(
//                               color: notificationController
//                                           .notificationStatus.value ==
//                                       "all"
//                                   ? whiteColor
//                                   : lightGrayColor2.withOpacity(0),
//                               boxShadow: notificationController
//                                           .notificationStatus.value ==
//                                       "all"
//                                   ? [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.5),
//                                         spreadRadius: 0.20,
//                                         blurRadius: 1,
//                                         offset: const Offset(
//                                             0, 0), // changes position of shadow
//                                       ),
//                                     ]
//                                   : [],
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             padding: const EdgeInsets.only(
//                                 top: 8, bottom: 8, left: 20, right: 20),
//                             child: Text(
//                               "All",
//                               style: TextStyles.regular14.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                   color: notificationController
//                                               .notificationStatus.value ==
//                                           "all"
//                                       ? blueColor
//                                       : grayColor),
//                             ));
//                       }),
//                     ),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         notificationController
//                             .changeNotificationStatus("unread");
//                       },
//                       child: Obx(() {
//                         return Container(
//                             decoration: BoxDecoration(
//                               color: notificationController
//                                           .notificationStatus.value ==
//                                       "unread"
//                                   ? whiteColor
//                                   : lightGrayColor2.withOpacity(0),
//                               boxShadow: notificationController
//                                           .notificationStatus.value ==
//                                       "unread"
//                                   ? [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.5),
//                                         spreadRadius: 0.20,
//                                         blurRadius: 1,
//                                         offset: const Offset(
//                                             0, 0), // changes position of shadow
//                                       ),
//                                     ]
//                                   : [],
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             padding: const EdgeInsets.only(
//                                 top: 8, bottom: 8, left: 20, right: 20),
//                             child: Text("Unread",
//                                 style: TextStyles.regular14.copyWith(
//                                     fontWeight: FontWeight.w600,
//                                     color: notificationController
//                                                 .notificationStatus.value ==
//                                             "unread"
//                                         ? blueColor
//                                         : grayColor)));
//                       }),
//                     ),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         notificationController.changeNotificationStatus("read");
//                       },
//                       child: Obx(() {
//                         return Container(
//                             decoration: BoxDecoration(
//                               color: notificationController
//                                           .notificationStatus.value ==
//                                       "read"
//                                   ? whiteColor
//                                   : lightGrayColor2.withOpacity(0),
//                               boxShadow: notificationController
//                                           .notificationStatus.value ==
//                                       "read"
//                                   ? [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.5),
//                                         spreadRadius: 0.20,
//                                         blurRadius: 1,
//                                         offset: const Offset(
//                                             0, 0), // changes position of shadow
//                                       ),
//                                     ]
//                                   : [],
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             padding: const EdgeInsets.only(
//                                 top: 8, bottom: 8, left: 20, right: 20),
//                             child: Text(
//                               "Read",
//                               style: TextStyles.regular14.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                   color: notificationController
//                                               .notificationStatus.value ==
//                                           "read"
//                                       ? blueColor
//                                       : grayColor),
//                             ));
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
    // ] )         
