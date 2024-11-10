import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:intl/intl.dart';

class DayViewPage extends StatelessWidget {
  final CalendarEventData holiday;
  final DateTime date;

  const DayViewPage({super.key, required this.holiday, required this.date});

  @override
  Widget build(BuildContext context) {
    final EventController eventController = EventController();
    // Format the date to only show date without time
    String formattedDate = DateFormat('yyyy-MM-dd').format(holiday.date);
    String formatDate(DateTime? date) {
      return DateFormat('EEE, yyyy-MM-dd').format(date!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Day View - $formattedDate",
          style: TextStyles.title16.copyWith(color: grayColor),
        ),
      ),
      body: DayView(
        controller: eventController
          ..add(CalendarEventData(
            date: date,
            endDate: holiday.endDate,
            title: holiday.title,
            event: holiday,
          )), // Add the selected event to the DayView
        onEventTap: (event, date) {
          // You can display event details or show a dialog
          Get.defaultDialog(
            title: holiday.title,
            content: Text(
                "Holiday from ${formatDate(holiday.date)} to ${formatDate(holiday.endDate)}"),
            confirm: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text("Close"),
            ),
          );
        },
      ),
    );
  }
}
