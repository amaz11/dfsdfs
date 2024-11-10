import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/notification/controller/notification_controller.dart';
import 'package:trealapp/module/notification/model/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationController notificationController;

  const NotificationItem({super.key, required this.notificationController});

  // Converts date string into "time ago" format
  String timeAgo(String dateString) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateString);
    Duration difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return "$years ${years == 1 ? 'year' : 'years'} ago";
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return "$months ${months == 1 ? 'month' : 'months'} ago";
    } else if (difference.inDays > 7) {
      int weeks = (difference.inDays / 7).floor();
      return "$weeks ${weeks == 1 ? 'week' : 'weeks'} ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
    }
    return "just now";
  }

  // Builds individual notification tile
  Widget buildNotificationTile(NotificationData notification) {
    return GestureDetector(
      onTap: () => notificationController.showModal(notification),
      child: Container(
        height: 110,
        margin: EdgeInsets.only(top: Dimensions.margin10),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.padding15,
          vertical: Dimensions.padding20,
        ),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: lightGrayColor2.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: lightGrayColor2.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(notification),
            const SizedBoxHight(hieght: 5),
            _buildFooter(notification),
          ],
        ),
      ),
    );
  }

  // Builds the header with title and message
  Widget _buildHeader(NotificationData notification) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title ?? "N/A",
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regular14.copyWith(
                  color: grayColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBoxHight(hieght: 5),
              Text(
                notification.message ?? "N/A",
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regular12.copyWith(
                  color: lightGrayColor.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (notification.read == "0")
          Padding(
            padding: EdgeInsets.only(top: Dimensions.padding10),
            child: const CircleAvatar(
              radius: 2.5,
              backgroundColor: blueColor,
            ),
          ),
      ],
    );
  }

  // Builds the footer with type and time
  Widget _buildFooter(NotificationData notification) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          notification.notificationType ?? "N/A",
          style: TextStyles.regular12.copyWith(
            color: lightGrayColor2,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          timeAgo(notification.notifiedAt!),
          style: TextStyles.regular12.copyWith(
            fontSize: 10,
            color: lightGrayColor.withOpacity(0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (notificationController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (notificationController.notificationData.isEmpty) {
        return _buildEmptyState(context);
      }

      return _buildNotificationList();
    });
  }

  // Builds the list of notifications
  Widget _buildNotificationList() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.padding10,
        vertical: Dimensions.padding20,
      ),
      child: RefreshIndicator(
        color: blueColor,
        onRefresh: notificationController.getNotificationMethod,
        child: ListView.builder(
          itemCount: notificationController.notificationData.length,
          itemBuilder: (context, index) {
            var notification = notificationController.notificationData[index];
            return buildNotificationTile(notification);
          },
        ),
      ),
    );
  }

  // Builds the empty state when no notifications are available
  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      color: blueColor,
      onRefresh: notificationController.getNotificationMethod,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 120),
              child: Text('No Notification found!'),
            ),
          ),
        ),
      ),
    );
  }
}
